import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function listOwnerApplications(req: Request, res: Response) {
  try {
    const owners = await prisma.owner.findMany({
      where: {},
      include: { user: true, shop: true }
    });
    const payload = owners.map(o => ({
      id: o.userId,
      fullName: o.fullName,
      phone: o.phone,
      status: o.status,
      shop: o.shop ? { id: o.shop.id, name: o.shop.name, address: o.shop.address, city: o.shop.city, district: o.shop.district } : null,
      createdAt: o.user.createdAt
    }));
    res.json(payload);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

export async function approveApplication(req: Request, res: Response) {
  try {
    const id = req.params.id; // userId
    const owner = await prisma.owner.findUnique({ where: { userId: id } });
    if (!owner) return res.status(404).json({ message: 'Owner not found' });
    await prisma.owner.update({ where: { userId: id }, data: { status: 'APPROVED' } });
    // create notification
    await prisma.notification.create({ data: { userId: id, title: 'Application Approved', body: 'Your owner application has been approved.' } });
    // send push to registered device tokens
    const tokens = await prisma.deviceToken.findMany({ where: { userId: id } });
    for (const t of tokens) {
      // lazy require to avoid adding heavy deps at module top
      const { sendPushToToken } = await import('../services/notificationService');
      sendPushToToken(t.token, 'Application Approved', 'Your owner application has been approved.');
    }
    res.json({ message: 'Owner approved' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

export async function rejectApplication(req: Request, res: Response) {
  try {
    const id = req.params.id; // userId
    const owner = await prisma.owner.findUnique({ where: { userId: id } });
    if (!owner) return res.status(404).json({ message: 'Owner not found' });
    await prisma.owner.update({ where: { userId: id }, data: { status: 'REJECTED' } });
    await prisma.notification.create({ data: { userId: id, title: 'Application Rejected', body: 'Your owner application has been rejected.' } });
    const tokens = await prisma.deviceToken.findMany({ where: { userId: id } });
    for (const t of tokens) {
      const { sendPushToToken } = await import('../services/notificationService');
      sendPushToToken(t.token, 'Application Rejected', 'Your owner application has been rejected.');
    }
    res.json({ message: 'Owner rejected' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}
