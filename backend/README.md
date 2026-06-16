# Barber Appointments Backend

This backend implements the REST API for the Barber Appointments platform using TypeScript, Express, and Prisma (Postgres).

Quick start (development):

- Copy `.env.example` to `.env` and update secrets.
- Start Postgres + backend via Docker Compose:

```bash
docker-compose up --build
```

- Or run locally inside `backend/`:

```bash
cd backend
npm install
npx prisma generate
npx prisma db push
npm run dev
```

OpenAPI documentation is available at `backend/docs/openapi.yaml`.

API endpoints (summary):

- Authentication
	- `POST /auth/register/customer` - register a customer (returns access & refresh tokens)
	- `POST /auth/register/owner` - submit owner application (status = PENDING)
	- `POST /auth/login/customer` - customer login
	- `POST /auth/login/owner` - owner login (only after approval)
	- `POST /auth/refresh` - exchange refresh token for access token
	- `POST /auth/logout` - revoke refresh token

- Appointments
	- `POST /appointments/request` - create appointment request (customer)
	- `PATCH /appointments/:id/approve` - approve appointment (owner)
	- `PATCH /appointments/:id/reject` - reject appointment (owner)
	- `GET /appointments` - list appointments (customer/owner/admin scoped)

- Admin
	- `GET /admin/owner-applications` - list owner applications (admin)
	- `PATCH /admin/owner-applications/:id/approve` - approve owner application
	- `PATCH /admin/owner-applications/:id/reject` - reject owner application

Security notes:

- Passwords are hashed using `bcrypt`.
- JWT access and refresh tokens are used; set `JWT_ACCESS_SECRET` and `JWT_REFRESH_SECRET`.
- Rate limiting, Helmet, and CORS are enabled.

Database:

- Prisma schema is in `prisma/schema.prisma`.
- To push schema to DB:

```bash
npx prisma generate
npx prisma db push
```

For production deployments, replace local secrets with a secrets manager and enable TLS.

Seeding an initial admin user

You can create an initial admin user for the dashboard with the seed script. By default it will create `admin@example.com` with password `AdminPass123!` unless you set environment variables.

```bash
# set env vars if you want to customize
SEED_ADMIN_EMAIL=you@domain.com SEED_ADMIN_PASSWORD=StrongPass123 npm run seed:admin --prefix backend
```

Or run the script directly inside the backend folder:

```bash
cd backend
SEED_ADMIN_EMAIL=you@domain.com SEED_ADMIN_PASSWORD=StrongPass123 node scripts/seedAdmin.js
```


