import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import cookieParser from 'cookie-parser';
import rateLimit from 'express-rate-limit';
import authRoutes from './routes/auth';
import adminRoutes from './routes/admin';
import appointmentsRoutes from './routes/appointments';
import notificationsRoutes from './routes/notifications';
import shopsRoutes from './routes/shops';
import adminUsersRoutes from './routes/adminUsers';

const app = express();

app.use(helmet());
app.use(cors({ origin: true, credentials: true }));
app.use(express.json());
app.use(cookieParser());

const limiter = rateLimit({
  windowMs: 1 * 60 * 1000,
  max: 100
});

app.use(limiter);

app.use('/auth', authRoutes);
app.use('/admin', adminRoutes);
app.use('/appointments', appointmentsRoutes);
app.use('/notifications', notificationsRoutes);
app.use('/shops', shopsRoutes);
app.use('/admin', adminUsersRoutes);

app.get('/', (req, res) => res.json({ ok: true }));

export default app;
