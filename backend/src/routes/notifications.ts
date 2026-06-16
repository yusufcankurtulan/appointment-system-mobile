import { Router } from 'express';
import { verifyAccessToken } from '../middleware/auth';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();
const router = Router();

// Register a device token for the authenticated user
router.post('/register', verifyAccessToken, async (req, res) => {
  try {
    const user = (req as any).user;
    const { token, platform } = req.body;
    if (!token) return res.status(400).json({ message: 'Missing token' });
    await prisma.deviceToken.upsert({ where: { token }, update: { userId: user.userId, platform }, create: { userId: user.userId, token, platform } });
    res.json({ message: 'Registered' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

// Unregister a device token
router.post('/unregister', verifyAccessToken, async (req, res) => {
  try {
    const { token } = req.body;
    if (!token) return res.status(400).json({ message: 'Missing token' });
    await prisma.deviceToken.deleteMany({ where: { token } });
    res.json({ message: 'Unregistered' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
});

export default router;
