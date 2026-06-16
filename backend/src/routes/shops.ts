import { Router } from 'express';
import * as shopsController from '../controllers/shopsController';
import { verifyAccessToken } from '../middleware/auth';

const router = Router();

router.get('/nearby', shopsController.getNearby);
router.get('/search', shopsController.searchShops);
router.get('/:id', shopsController.getShopById);

// protected routes for owners to manage shop
router.post('/:id/images', verifyAccessToken, shopsController.addShopImage);
router.post('/:id/images/upload', verifyAccessToken, shopsController.uploadShopImage);
router.get('/:id/chairs', shopsController.getChairs);
router.post('/:id/chairs', verifyAccessToken, shopsController.createChair);

export default router;
