# ASD Backend

Node.js + Express service that exposes authentication, questionnaire, and assessment result APIs backed by a Prisma-managed SQLite database.

## Prerequisites

- Node.js 18+
- npm 9+

## Setup

```powershell
cd server
copy .env.example .env   # then edit JWT_SECRET / DATABASE_URL if needed
npm install
npx prisma migrate dev --name init
```

The migrate step also runs `prisma/seed.ts`, which inserts the default M-CHAT questionnaire. You can re-run it anytime with `npx prisma db seed`.

## Scripts

```powershell
npm run dev         # Start Express API with tsx + hot reload
npm run build       # Type-check and emit compiled JS to dist/
npm run start       # Run the compiled build
npm run lint        # Type-check only
npm run prisma:migrate -- --name <label>   # Create/apply migrations
npm run prisma:studio                      # Inspect data visually
```

## API Surface

| Method | Path                                          | Description                                                         |
| ------ | --------------------------------------------- | ------------------------------------------------------------------- |
| `POST` | `/api/auth/register`                          | Create a user and return a JWT.                                     |
| `POST` | `/api/auth/login`                             | Exchange email/password for a JWT.                                  |
| `GET`  | `/api/auth/me`                                | Retrieve the authenticated user's profile.                          |
| `GET`  | `/api/questionnaires`                         | List all questionnaires.                                            |
| `GET`  | `/api/questionnaires/:identifier`             | Fetch a questionnaire (by slug or ID) with questions.               |
| `POST` | `/api/questionnaires/:identifier/submissions` | Submit answers, calculate risk, and persist a result. JWT optional. |
| `GET`  | `/api/results`                                | List the caller's assessment results. JWT required.                 |
| `GET`  | `/api/results/:id`                            | Fetch a single result (must belong to caller).                      |

All protected routes expect an `Authorization: Bearer <token>` header with the JWT issued during login/registration.

## Folder Structure

```
server/
  src/
    app.ts              # Express wiring
    config/env.ts       # zod-validated env loader
    lib/prisma.ts       # Prisma client singleton
    middleware/         # auth + error handlers
    modules/            # Feature-specific routers/controllers
    routes/             # API router composition
    utils/              # Shared helpers (crypto, scoring, etc.)
  prisma/
    schema.prisma       # Data model
    seed.ts             # Data loader for questionnaires
    seed-data/          # Questionnaire fixtures
```

## Next Steps

- Implement Flutter HTTP clients that talk to the `/api` routes instead of the current Supabase mock data.
- Expand the schema with additional questionnaires or clinician review workflows as requirements evolve.
