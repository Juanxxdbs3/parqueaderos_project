import express from 'express';
import { authenticate } from '../middleware/auth.js';
import { getUserById } from '../services/user_service.js';

const router = express.Router();
router.get('/:id', authenticate, async (req, res, next) => {
  try {
    const user = await getUserById(req.params.id);
    res.json(user);
  } catch (err) {
    next(err);
  }
});
export default router;
