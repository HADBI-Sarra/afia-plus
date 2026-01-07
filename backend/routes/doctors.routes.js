import express from 'express';
import { authMiddleware } from '../middlewares/auth.middleware.js';
import { getMe, getSpecialities, getDoctorsBySpeciality } from '../controllers/doctors.controller.js';

const router = express.Router();

router.get('/me', authMiddleware, getMe);
// Popular specializations (all specialities)
router.get('/specialities', getSpecialities);
// All doctors for a given specialitiy
router.get('/by-speciality', getDoctorsBySpeciality);

export default router;

