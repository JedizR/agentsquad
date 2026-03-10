# Backend Engineer — API Patterns Reference

## REST Conventions

### URL Structure
```
GET    /api/v1/resources          # List (with pagination)
GET    /api/v1/resources/:id      # Get one
POST   /api/v1/resources          # Create
PUT    /api/v1/resources/:id      # Replace (full update)
PATCH  /api/v1/resources/:id      # Partial update
DELETE /api/v1/resources/:id      # Delete
```

### Pagination (always use for list endpoints)
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "perPage": 20,
    "total": 145,
    "totalPages": 8
  }
}
```

### Standard Error Shape
```json
{
  "error": "VALIDATION_ERROR",
  "message": "Human-readable description",
  "status": 400,
  "details": [
    { "field": "email", "message": "Email is required" }
  ]
}
```

### HTTP Status Codes
| Code | When |
|------|------|
| 200 | Success (GET, PATCH, PUT) |
| 201 | Created (POST) |
| 204 | No content (DELETE) |
| 400 | Validation error |
| 401 | Not authenticated |
| 403 | Authenticated but not authorized |
| 404 | Resource not found |
| 409 | Conflict (e.g., duplicate email) |
| 422 | Unprocessable entity |
| 429 | Rate limited |
| 500 | Internal server error |

## Input Validation Pattern (zod)
```typescript
import { z } from 'zod';

const CreateUserSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8),
  name: z.string().min(1).max(100),
});

// In handler:
const body = CreateUserSchema.parse(req.body); // throws ZodError on invalid
```

## Service Layer Pattern
```typescript
// Always: controller → service → repository (never skip layers)
// controller: HTTP in/out, no business logic
// service: business logic, no HTTP concepts
// repository: database queries only, no business logic

class AuthService {
  constructor(private readonly userRepo: UserRepository) {}

  async login(email: string, password: string): Promise<AuthResult> {
    const user = await this.userRepo.findByEmail(email);
    if (!user) throw new AppError('INVALID_CREDENTIALS', 401);
    // ...
  }
}
```

## JSDoc Standard
```typescript
/**
 * Creates a new user account and sends a verification email.
 * @param dto - Validated user creation data
 * @returns The created user (without password hash)
 * @throws {AppError} DUPLICATE_EMAIL if the email is already registered
 */
async createUser(dto: CreateUserDto): Promise<User> { ... }
```
