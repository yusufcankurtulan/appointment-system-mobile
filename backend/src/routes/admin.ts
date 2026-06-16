import { Router } from 'express';
import * as adminController from '../controllers/adminController';
import { verifyAccessToken, requireRole } from '../middleware/auth';

const router = Router();

router.use(verifyAccessToken, requireRole('ADMIN'));

router.get('/owner-applications', adminController.listOwnerApplications);
router.patch('/owner-applications/:id/approve', adminController.approveApplication);
router.patch('/owner-applications/:id/reject', adminController.rejectApplication);

export default router;
