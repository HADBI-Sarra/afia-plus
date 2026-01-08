import express from 'express';
import cors from 'cors';

import authRoutes from '../routes/auth.routes.js';
import userRoutes from '../routes/users.routes.js';
import patientRoutes from '../routes/patients.routes.js';
import doctorRoutes from '../routes/doctors.routes.js';
import doctorAvailabilityRoutes from '../routes/doctor_availability.routes.js';
import consultationsRoutes from '../routes/consultations.routes.js';
import deviceTokenRoutes from '../routes/deviceToken.routes.js';

const app = express();

app.use(cors());
app.use(express.json());

app.use('/auth', authRoutes);
app.use('/users', userRoutes);
app.use('/patients', patientRoutes);
app.use('/doctors', doctorRoutes);
app.use('/availability', doctorAvailabilityRoutes);
app.use('/consultations', consultationsRoutes);
app.use('/device-tokens', deviceTokenRoutes);

export default app;
