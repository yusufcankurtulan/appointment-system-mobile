import { Router } from 'express';
import * as authController from '../controllers/authController';

const router = Router();

router.post('/register/customer', authController.registerCustomer);
router.post('/register/owner', authController.registerOwner);
router.post('/login/customer', authController.loginCustomer);
router.post('/login/owner', authController.loginOwner);
router.post('/login/admin', authController.loginAdmin);
router.post('/refresh', authController.refreshToken);
router.post('/logout', authController.logout);

export default router;
