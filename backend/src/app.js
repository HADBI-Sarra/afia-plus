import express from 'express';
import cors from 'cors';

import authRoutes from '../routes/auth.routes.js';
import userRoutes from '../routes/users.routes.js';
import patientRoutes from '../routes/patients.routes.js';

const app = express();

app.use(cors());
app.use(express.json());

app.use('/auth', authRoutes);
app.use('/users', userRoutes);
app.use('/patients', patientRoutes);

export default app;
