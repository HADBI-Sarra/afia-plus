import express from 'express';
import { authMiddleware } from '../middlewares/auth.middleware.js';
import { getMe } from '../controllers/doctors.controller.js';

const router = express.Router();

router.get('/me', authMiddleware, getMe);

export default router;

