const bcrypt = require('bcrypt');
const { PrismaClient } = require('@prisma/client');
const dotenv = require('dotenv');

dotenv.config();

const prisma = new PrismaClient();

async function seed() {
  const email = process.env.SEED_ADMIN_EMAIL || 'admin@example.com';
  const password = process.env.SEED_ADMIN_PASSWORD || 'AdminPass123!';

  try {
    const existing = await prisma.user.findUnique({ where: { email } });
    if (existing) {
      console.log('Admin user already exists:', email);
      return process.exit(0);
    }

    const hashed = await bcrypt.hash(password, 10);
    const user = await prisma.user.create({ data: { email, password: hashed, role: 'ADMIN' } });
    console.log('Created admin user:', user.id, email);
  } catch (err) {
    console.error('Failed to seed admin:', err);
    process.exit(1);
  } finally {
    await prisma.$disconnect();
  }
}

seed();
