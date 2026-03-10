# Backend Engineer — Database Patterns Reference

## Schema Design Principles
- Always include: `id`, `created_at`, `updated_at` on every table
- Use UUIDs for IDs (not auto-increment integers) — portable and non-guessable
- Soft delete with `deleted_at` timestamp (never hard delete user data)
- Foreign keys always have explicit ON DELETE behavior defined

## Standard Table Template
```sql
CREATE TABLE users (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email       VARCHAR(255) NOT NULL UNIQUE,
  name        VARCHAR(100) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  deleted_at  TIMESTAMPTZ -- soft delete
);

CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_deleted_at ON users(deleted_at) WHERE deleted_at IS NULL;
```

## Migration Conventions
```
migrations/
  001_create_users.sql
  002_add_role_to_users.sql
  003_create_subscriptions.sql
```
- Sequential numbering, descriptive names
- Always include UP migration; include DOWN migration for local dev
- Never modify an existing migration — create a new one

## Index Strategy
```sql
-- Index every foreign key
CREATE INDEX idx_posts_user_id ON posts(user_id);

-- Partial index for soft delete (massive performance win)
CREATE INDEX idx_users_active ON users(email) WHERE deleted_at IS NULL;

-- Composite index when queries filter on multiple columns together
CREATE INDEX idx_subscriptions_user_status ON subscriptions(user_id, status);
```

## N+1 Prevention
```typescript
// BAD: N+1
const users = await db.query('SELECT * FROM users');
for (const user of users) {
  user.posts = await db.query('SELECT * FROM posts WHERE user_id = $1', [user.id]);
}

// GOOD: JOIN or separate batch query
const users = await db.query(`
  SELECT u.*, json_agg(p.*) as posts
  FROM users u
  LEFT JOIN posts p ON p.user_id = u.id
  GROUP BY u.id
`);
```

## Transactions
```typescript
// Wrap multi-step operations in a transaction
await db.transaction(async (trx) => {
  const user = await trx('users').insert(userData).returning('*');
  await trx('email_verifications').insert({ user_id: user[0].id, token });
  // If any step throws, both are rolled back automatically
});
```
