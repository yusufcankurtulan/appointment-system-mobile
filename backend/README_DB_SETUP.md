Database setup and migrations

This document explains how to initialize the local PostgreSQL (via Docker Compose), apply the Prisma schema, seed the initial admin, and create migration files for production.

Prerequisites
- Docker Desktop installed and running
- Node.js (>=16) and npm installed
- From project root

Local quick setup (non-destructive if you already have data):
```bash
# start only postgres service (from project root)
docker compose up -d postgres

# go to backend
cd backend

# generate prisma client
npx prisma generate

# apply schema to the database (push)
npx prisma db push --accept-data-loss

# seed initial admin
npm run seed:admin

# start backend in dev
npm run dev
```

If you prefer a single command from `backend` you can run:
```bash
npm run db:setup
```

Troubleshooting P1010 ("User `postgres` was denied access")
- Cause 1: The `DATABASE_URL` in `backend/.env` points to `localhost:5432`, but the host's `localhost:5432` is not the Postgres container (or another Postgres is bound on that port). When running Prisma commands from your host machine, `localhost:5432` should point to the container because docker-compose maps the port. Verify with:
  ```bash
  docker compose ps
  lsof -i :5432 || true
  ```
- Cause 2: Postgres data volume was initialized previously with a different `POSTGRES_PASSWORD` and now the password in `.env` doesn't match the DB's postgres user password. To fix non-destructively, run:
  ```bash
  docker compose exec postgres psql -U postgres -c "ALTER USER postgres WITH PASSWORD 'postgres';"
  ```
  Then retry `npx prisma db push`.
- If the above fails and you don't need existing DB data, remove the volume and recreate the DB to match the `docker-compose.yml` credentials:
  ```bash
  docker compose down -v
  docker compose up -d
  ```

Creating migrations for production (recommended)

Prisma `db push` is convenient for development, but for production you should use migration files and a migration workflow.

1. After your schema is stable, create a migration locally (this will apply it to the database and create a migration folder):
```bash
cd backend
npx prisma migrate dev --name init
```
This will:
- create `prisma/migrations/<timestamp>_init/` with SQL migration files
- update your local database

2. Commit the `prisma/migrations` directory to your repo and push to your remote.

3. On production, run migrations (do NOT use `db push` for prod):
```bash
# on production server or CI
cd backend
npx prisma migrate deploy
```

Notes
- Always backup your DB before applying migrations in production.
- Use environment variables for DB credentials and keep secrets out of repo.

If you want, I can generate an initial migration file template for you, but it's safer to run `npx prisma migrate dev --name init` on your machine so the generated SQL exactly matches the Prisma CLI version and your local DB state.
