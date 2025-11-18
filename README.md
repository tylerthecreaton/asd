# asd

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Health checks

Run these commands before committing to make sure the project stays healthy:

```powershell
flutter analyze
flutter test
```

> Note: The current `file_picker` dependency emits platform plugin warnings on Windows, macOS, and Linux during the commands above. They are upstream notices and do not block analysis or tests.

## Backend API (Node.js + Prisma)

The `server/` folder now contains an Express + Prisma backend that exposes authentication, questionnaire, and assessment-result endpoints backed by a SQLite database.

1. Install dependencies and copy the environment template:

   ```powershell
   cd server
   copy .env.example .env
   npm install
   ```

2. Run the initial migration (creates/updates the SQLite database and seeds questionnaires):

   ```powershell
   npx prisma migrate dev --name init
   ```

3. Start the API locally:

   ```powershell
   npm run dev
   ```

See `server/README.md` for endpoint details, available scripts, and architectural notes.
