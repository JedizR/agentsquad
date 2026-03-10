# DevOps Engineer — Output Format Reference

## Full Example Output

```
FILES CREATED:
- .github/workflows/ci.yml (created)
- .github/workflows/deploy.yml (created)
- docker/Dockerfile (created)
- docker/docker-compose.yml (created)
- .dockerignore (created)
- .env.example (modified — added RAILWAY_TOKEN)

WHAT THIS ENABLES:
Push to main → automated tests run on GitHub Actions → Docker image built and
pushed to GitHub Container Registry → deployed to Railway automatically.

HOW TO TEST LOCALLY:
docker-compose up --build
# App will be at http://localhost:3000
# Database will be at localhost:5432

[REQUIRES MANUAL STEP]: Add to GitHub Secrets:
  - RAILWAY_TOKEN (from railway.app dashboard → Project → Settings → Tokens)
  - GHCR_TOKEN (GitHub → Settings → Developer settings → Personal access tokens → packages:write)

[COST IMPLICATION]: Railway Pro plan required for always-on instances (~$5/mo per service)
[COST IMPLICATION]: GitHub Actions free tier: 2,000 minutes/month (CI runs ~3 min each → ~600 runs free)

⚠️ ESCALATIONS:
[ESCALATE TO CLAUDE]: Multi-region deployment needed? Single region (US-West) assumed.
Production database auto-migration is configured — confirm this is acceptable for this stage.
```

## Rules
1. FILES CREATED lists every file touched — no omissions
2. WHAT THIS ENABLES is plain English (non-DevOps team members will read this)
3. HOW TO TEST LOCALLY must be a working command, not a description
4. [REQUIRES MANUAL STEP] is mandatory for every new secret or external service
5. [COST IMPLICATION] is mandatory for any paid service (even if $0 on free tier — note the limit)
6. ESCALATIONS: escalate any production database migration decisions always
