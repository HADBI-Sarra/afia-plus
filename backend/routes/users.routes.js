import express from 'express';
import { authMiddleware } from '../middlewares/auth.middleware.js';
import {
  updateMe,
  emailExists
} from '../controllers/users.controller.js';

const router = express.Router();

router.get('/email-exists', emailExists);
router.put('/me', authMiddleware, updateMe);

export default router;
