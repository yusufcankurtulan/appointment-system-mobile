import { Request, Response } from 'express';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const ACCESS_EXPIRES = process.env.ACCESS_TOKEN_EXPIRES_IN || '15m';
const REFRESH_EXPIRES = process.env.REFRESH_TOKEN_EXPIRES_IN || '7d';

function signAccessToken(user: any) {
  // cast secret/options to any to satisfy TypeScript typings across jsonwebtoken versions
  return jwt.sign({ userId: user.id, role: user.role } as any, (process.env.JWT_ACCESS_SECRET || 'secret') as any, { expiresIn: ACCESS_EXPIRES } as any);
}

function signRefreshToken(user: any) {
  return jwt.sign({ userId: user.id } as any, (process.env.JWT_REFRESH_SECRET || 'refreshsecret') as any, { expiresIn: REFRESH_EXPIRES } as any);
}

export async function registerCustomer(req: Request, res: Response) {
  try {
    const { firstName, lastName, email, phone, password } = req.body;
    if (!firstName || !lastName || !email || !phone || !password) return res.status(400).json({ message: 'Missing fields' });

    const existing = await prisma.user.findUnique({ where: { email } });
    if (existing) return res.status(409).json({ message: 'Email already in use' });

    const hashed = await bcrypt.hash(password, 10);
    const user = await prisma.user.create({
      data: {
        email,
        password: hashed,
        role: 'CUSTOMER'
      }
    });

    await prisma.customer.create({ data: { userId: user.id, firstName, lastName, phone } });

    const accessToken = signAccessToken(user);
    const refreshToken = signRefreshToken(user);

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);

    await prisma.refreshToken.create({ data: { userId: user.id, token: refreshToken, expiresAt } });

    res.json({ accessToken, refreshToken, user: { id: user.id, email: user.email, role: user.role } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

export async function registerOwner(req: Request, res: Response) {
  try {
    const { fullName, email, phone, password, shop } = req.body;
    if (!fullName || !email || !phone || !password || !shop) return res.status(400).json({ message: 'Missing fields' });

    const existing = await prisma.user.findUnique({ where: { email } });
    if (existing) return res.status(409).json({ message: 'Email already in use' });

    const hashed = await bcrypt.hash(password, 10);
    const user = await prisma.user.create({
      data: {
        email,
        password: hashed,
        role: 'OWNER'
      }
    });

    await prisma.owner.create({ data: { userId: user.id, fullName, phone, status: 'PENDING' } });

    // Create shop record in pending state (owner will be linked)
    await prisma.shop.create({ data: { ownerId: user.id, name: shop.name, description: shop.description || null, city: shop.city, district: shop.district || null, address: shop.address, latitude: shop.latitude || null, longitude: shop.longitude || null } });

    res.json({ message: 'Owner application submitted', status: 'PENDING' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

export async function loginCustomer(req: Request, res: Response) {
  try {
    const { email, password } = req.body;

    console.log('[LOGIN CUSTOMER]', email);

    if (!email || !password) {
      return res.status(400).json({
        message: 'Missing fields',
      });
    }

    const user = await prisma.user.findUnique({
      where: { email },
    });

    console.log('[USER FOUND]', user);

    if (!user) {
      return res.status(401).json({
        message: 'User not found',
      });
    }

    if (user.disabled) {
      return res.status(403).json({
        message: 'Account disabled',
      });
    }

    if (user.role !== 'CUSTOMER') {
      return res.status(401).json({
        message: 'This account is not a customer account',
      });
    }

    const passwordMatch = await bcrypt.compare(
      password,
      user.password,
    );

    console.log('[PASSWORD MATCH]', passwordMatch);

    if (!passwordMatch) {
      return res.status(401).json({
        message: 'Wrong password',
      });
    }

    const accessToken = signAccessToken(user);
    const refreshToken = signRefreshToken(user);

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);

    await prisma.refreshToken.create({
      data: {
        userId: user.id,
        token: refreshToken,
        expiresAt,
      },
    });

    return res.json({
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        email: user.email,
        role: user.role,
      },
    });
  } catch (err) {
    console.error('[LOGIN CUSTOMER ERROR]', err);

    return res.status(500).json({
      message: 'Server error',
    });
  }
}

export async function loginOwner(req: Request, res: Response) {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ message: 'Missing fields' });

    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) return res.status(401).json({ message: 'Invalid credentials' });
    if (user.disabled) return res.status(403).json({ message: 'Account disabled' });
    if (!user || user.role !== 'OWNER') return res.status(401).json({ message: 'Invalid credentials' });

    // ensure owner is approved
    const owner = await prisma.owner.findUnique({ where: { userId: user.id } });
    if (!owner) return res.status(401).json({ message: 'Owner not found' });
    if (owner.status !== 'APPROVED') return res.status(403).json({ message: 'Owner application not approved' });

    const ok = await bcrypt.compare(password, user.password);
    if (!ok) return res.status(401).json({ message: 'Invalid credentials' });

    const accessToken = signAccessToken(user);
    const refreshToken = signRefreshToken(user);

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);
    await prisma.refreshToken.create({ data: { userId: user.id, token: refreshToken, expiresAt } });

    res.json({ accessToken, refreshToken, user: { id: user.id, email: user.email, role: user.role } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

export async function loginAdmin(req: Request, res: Response) {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ message: 'Missing fields' });

    const user = await prisma.user.findUnique({ where: { email } });
    if (!user) return res.status(401).json({ message: 'Invalid credentials' });
    if (user.disabled) return res.status(403).json({ message: 'Account disabled' });
    if (!user || user.role !== 'ADMIN') return res.status(401).json({ message: 'Invalid credentials' });

    const ok = await bcrypt.compare(password, user.password);
    if (!ok) return res.status(401).json({ message: 'Invalid credentials' });

    const accessToken = signAccessToken(user);
    const refreshToken = signRefreshToken(user);

    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);
    await prisma.refreshToken.create({ data: { userId: user.id, token: refreshToken, expiresAt } });

    res.json({ accessToken, refreshToken, user: { id: user.id, email: user.email, role: user.role } });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

export async function refreshToken(req: Request, res: Response) {
  try {
    const { token } = req.body;
    if (!token) return res.status(400).json({ message: 'No token provided' });

    const stored = await prisma.refreshToken.findUnique({ where: { token } });
    if (!stored) return res.status(401).json({ message: 'Invalid refresh token' });

    jwt.verify(token, process.env.JWT_REFRESH_SECRET || 'refreshsecret', async (err: any, decoded: any) => {
      if (err) return res.status(401).json({ message: 'Invalid token' });
      const user = await prisma.user.findUnique({ where: { id: decoded.userId } });
      if (!user) return res.status(401).json({ message: 'User not found' });
      const accessToken = signAccessToken(user);
      res.json({ accessToken });
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

export async function logout(req: Request, res: Response) {
  try {
    const { token } = req.body;
    if (!token) return res.status(400).json({ message: 'No token provided' });
    await prisma.refreshToken.deleteMany({ where: { token } });
    res.json({ message: 'Logged out' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}
