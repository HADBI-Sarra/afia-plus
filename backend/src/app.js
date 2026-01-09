import express from 'express';
import cors from 'cors';

import authRoutes from '../routes/auth.routes.js';
import userRoutes from '../routes/users.routes.js';
import patientRoutes from '../routes/patients.routes.js';
import doctorRoutes from '../routes/doctors.routes.js';
import doctorAvailabilityRoutes from '../routes/doctor_availability.routes.js';
import consultationsRoutes from '../routes/consultations.routes.js';

const app = express();

app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));

app.use('/auth', authRoutes);
app.use('/users', userRoutes);
app.use('/patients', patientRoutes);
app.use('/doctors', doctorRoutes);
app.use('/availability', doctorAvailabilityRoutes);
app.use('/consultations', consultationsRoutes);

export default app;
