import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export function verifyAccessToken(req: Request, res: Response, next: NextFunction) {
  const auth = req.headers.authorization;
  if (!auth) return res.status(401).json({ message: 'No authorization header' });
  const parts = auth.split(' ');
  if (parts.length !== 2 || parts[0] !== 'Bearer') return res.status(401).json({ message: 'Invalid authorization header' });
  const token = parts[1];
  jwt.verify(token, process.env.JWT_ACCESS_SECRET || 'secret', (err: any, decoded: any) => {
    if (err) return res.status(401).json({ message: 'Invalid token' });
    (req as any).user = decoded;
    next();
  });
}

export function requireRole(role: string) {
  return (req: Request, res: Response, next: NextFunction) => {
    const user = (req as any).user;
    if (!user) return res.status(401).json({ message: 'Unauthorized' });
    if (user.role !== role) return res.status(403).json({ message: 'Forbidden' });
    next();
  };
}
