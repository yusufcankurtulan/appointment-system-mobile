import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function listUsers(req: Request, res: Response) {
  try {
    const users = await prisma.user.findMany({ select: { id: true, email: true, role: true, createdAt: true, disabled: true } });
    res.json(users);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

export async function disableUser(req: Request, res: Response) {
  try {
    const id = req.params.id;
    await prisma.user.update({ where: { id }, data: { disabled: true } });
    res.json({ message: 'User disabled' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

export async function enableUser(req: Request, res: Response) {
  try {
    const id = req.params.id;
    await prisma.user.update({ where: { id }, data: { disabled: false } });
    res.json({ message: 'User enabled' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

export async function deleteUser(req: Request, res: Response) {
  try {
    const id = req.params.id;
    await prisma.user.delete({ where: { id } });
    res.json({ message: 'User deleted' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}
