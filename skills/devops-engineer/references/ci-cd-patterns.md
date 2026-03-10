# DevOps Engineer — CI/CD Patterns Reference

## Standard GitHub Actions Structure
```
.github/
  workflows/
    ci.yml        # Run on every PR: lint → test → build
    deploy.yml    # Run on push to main: ci → docker build → deploy
    shellcheck.yml # Lint all .sh files on PR
```

## CI Pipeline Template (ci.yml)
```yaml
name: CI
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
          cache: 'npm'
      - run: npm ci
      - run: npm run lint
      - run: npm run type-check
      - run: npm test -- --coverage
      - run: npm run build
```

## Deploy Pipeline Template (deploy.yml)
```yaml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    needs: [test]  # Always run tests first
    steps:
      - uses: actions/checkout@v4
      - name: Deploy to Railway
        env:
          RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
        run: npx railway up
```

## Secret Annotation Pattern
Every workflow that needs a secret must include:
```yaml
# [REQUIRES MANUAL STEP]: Add to GitHub Secrets:
#   - SECRET_NAME: Description of where to get it
env:
  SECRET_NAME: ${{ secrets.SECRET_NAME }}
```

## Environment Separation
```
Branches:
  feature/* → no deployment
  develop   → staging deployment
  main      → production deployment

Environment variables per environment:
  .env.development  (local — never committed)
  .env.staging      (CI — stored in GitHub Secrets)
  .env.production   (CI — stored in GitHub Secrets)
```
