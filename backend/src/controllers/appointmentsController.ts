import { Request, Response } from 'express';
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

export async function requestAppointment(req: Request, res: Response) {
  try {
    const user = (req as any).user;
    const { chairId, shopId, startAt, endAt } = req.body;
    if (!chairId || !shopId || !startAt || !endAt) return res.status(400).json({ message: 'Missing fields' });

    const start = new Date(startAt);
    const end = new Date(endAt);
    if (start >= end) return res.status(400).json({ message: 'Invalid time range' });

    // Check overlapping appointments for the chair
    const overlapping = await prisma.appointment.findFirst({
      where: {
        chairId,
        status: { in: ['PENDING', 'APPROVED'] },
        startAt: { lt: end },
        endAt: { gt: start }
      }
    });
    if (overlapping) return res.status(409).json({ message: 'Selected slot is not available' });

    const appt = await prisma.appointment.create({ data: { customerId: user.userId, chairId, shopId, startAt: start, endAt: end, status: 'PENDING' } });
    // notify owner(s) - create notifications for shop owner
    const shop = await prisma.shop.findUnique({ where: { id: shopId } });
    if (shop) {
      await prisma.notification.create({ data: { userId: shop.ownerId, title: 'New Appointment Request', body: 'You have a new appointment request.' } });
      const tokens = await prisma.deviceToken.findMany({ where: { userId: shop.ownerId } });
      for (const t of tokens) {
        const { sendPushToToken } = await import('../services/notificationService');
        sendPushToToken(t.token, 'New Appointment Request', 'You have a new appointment request.');
      }
    }
    res.json(appt);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

export async function approveAppointment(req: Request, res: Response) {
  try {
    const user = (req as any).user;
    const id = req.params.id;
    const appt = await prisma.appointment.findUnique({ where: { id }, include: { shop: true } });
    if (!appt) return res.status(404).json({ message: 'Appointment not found' });
    if (!appt.shop || appt.shop.ownerId !== user.userId) return res.status(403).json({ message: 'Forbidden' });

    // Ensure no conflict when approving
    const overlapping = await prisma.appointment.findFirst({
      where: {
        id: { not: id },
        chairId: appt.chairId,
        status: { in: ['PENDING', 'APPROVED'] },
        startAt: { lt: appt.endAt },
        endAt: { gt: appt.startAt }
      }
    });
    if (overlapping) return res.status(409).json({ message: 'Time slot conflicts with another appointment' });

    const updated = await prisma.appointment.update({ where: { id }, data: { status: 'APPROVED' } });
    await prisma.notification.create({ data: { userId: updated.customerId, title: 'Appointment Approved', body: 'Your appointment has been approved.' } });
    const tokens = await prisma.deviceToken.findMany({ where: { userId: updated.customerId } });
    for (const t of tokens) {
      const { sendPushToToken } = await import('../services/notificationService');
      sendPushToToken(t.token, 'Appointment Approved', 'Your appointment has been approved.');
    }
    res.json(updated);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

export async function rejectAppointment(req: Request, res: Response) {
  try {
    const user = (req as any).user;
    const id = req.params.id;
    const appt = await prisma.appointment.findUnique({ where: { id }, include: { shop: true } });
    if (!appt) return res.status(404).json({ message: 'Appointment not found' });
    if (!appt.shop || appt.shop.ownerId !== user.userId) return res.status(403).json({ message: 'Forbidden' });

    const updated = await prisma.appointment.update({ where: { id }, data: { status: 'REJECTED' } });
    await prisma.notification.create({ data: { userId: updated.customerId, title: 'Appointment Rejected', body: 'Your appointment has been rejected.' } });
    const tokens = await prisma.deviceToken.findMany({ where: { userId: updated.customerId } });
    for (const t of tokens) {
      const { sendPushToToken } = await import('../services/notificationService');
      sendPushToToken(t.token, 'Appointment Rejected', 'Your appointment has been rejected.');
    }
    res.json(updated);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}

export async function getAppointments(req: Request, res: Response) {
  try {
    const user = (req as any).user;
    const role = user.role;
    let appointments;
    if (role === 'CUSTOMER') {
      appointments = await prisma.appointment.findMany({ where: { customerId: user.userId }, include: { chair: true, shop: true } });
    } else if (role === 'OWNER') {
      // find shops owned by owner
      const shops = await prisma.shop.findMany({ where: { ownerId: user.userId } });
      const shopIds = shops.map(s => s.id);
      appointments = await prisma.appointment.findMany({ where: { shopId: { in: shopIds } }, include: { chair: true, shop: true, customer: true } });
    } else if (role === 'ADMIN') {
      appointments = await prisma.appointment.findMany({ include: { chair: true, shop: true, customer: true } });
    } else {
      return res.status(403).json({ message: 'Forbidden' });
    }
    res.json(appointments);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server error' });
  }
}
