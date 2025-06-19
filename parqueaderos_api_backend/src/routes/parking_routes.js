import express from 'express';
import { authenticate } from '../middleware/auth.js';
import { createParkingController, getNearbyController } from '../controllers/parking_controller.js';

const router = express.Router();
router.post('/',        authenticate, createParkingController);
router.get('/nearby',   authenticate, getNearbyController);
export default router;
