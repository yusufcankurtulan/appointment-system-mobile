import { Router } from 'express';
import * as appointmentsController from '../controllers/appointmentsController';
import { verifyAccessToken, requireRole } from '../middleware/auth';

const router = Router();

router.post('/request', verifyAccessToken, requireRole('CUSTOMER'), appointmentsController.requestAppointment);
router.patch('/:id/approve', verifyAccessToken, requireRole('OWNER'), appointmentsController.approveAppointment);
router.patch('/:id/reject', verifyAccessToken, requireRole('OWNER'), appointmentsController.rejectAppointment);
router.get('/', verifyAccessToken, appointmentsController.getAppointments);

export default router;
