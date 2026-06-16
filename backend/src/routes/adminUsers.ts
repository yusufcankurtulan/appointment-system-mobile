import { Router } from 'express';
import * as adminUsersController from '../controllers/adminUsersController';
import { verifyAccessToken, requireRole } from '../middleware/auth';

const router = Router();

router.use(verifyAccessToken, requireRole('ADMIN'));

router.get('/users', adminUsersController.listUsers);
router.patch('/users/:id/disable', adminUsersController.disableUser);
router.patch('/users/:id/enable', adminUsersController.enableUser);
router.delete('/users/:id', adminUsersController.deleteUser);

export default router;
