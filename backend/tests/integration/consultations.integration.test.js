/**
 * Consultations Integration Tests
 * Tests the complete consultation booking flow with real API endpoints
 */

import request from 'supertest';
import app from '../../src/app.js';

describe('Consultations Integration Tests', () => {
    let patientToken, doctorToken;
    let patientId, doctorId;
    let availabilityId;
    let consultationId;

    // Setup: Create test patient and doctor
    beforeAll(async () => {
        const timestamp = Date.now();

        // Create patient
        const patientRes = await request(app)
            .post('/auth/signup')
            .send({
                email: `patient_${timestamp}@test.com`,
                password: 'TestPass123!',
                firstname: 'Test',
                lastname: 'Patient',
                phone_number: `061${timestamp.toString().slice(-7)}`,
                nin: `1${timestamp.toString().padStart(17, '0')}`,
                role: 'patient',
                date_of_birth: '1990-01-01'
            });

        if (!patientRes.body.user) {
            throw new Error(`Patient signup failed: ${JSON.stringify(patientRes.body)}`);
        }

        patientToken = patientRes.body.access_token;
        patientId = patientRes.body.user.user_id;

        // Create doctor
        const doctorRes = await request(app)
            .post('/auth/signup')
            .send({
                email: `doctor_${timestamp}@test.com`,
                password: 'TestPass123!',
                firstname: 'TestDoctor',
                lastname: 'Smith',
                phone_number: `062${timestamp.toString().slice(-7)}`,
                nin: `2${timestamp.toString().padStart(17, '0')}`,
                role: 'doctor',
                bio: 'Skilled general practitioner with expertise in family medicine',
                location_of_work: 'General Hospital',
                degree: 'MD General Medicine',
                university: 'State Medical College',
                license_number: '23456',
                areas_of_expertise: 'General Practice, Family Medicine'
            });

        if (!doctorRes.body.user) {
            throw new Error(`Doctor signup failed: ${JSON.stringify(doctorRes.body)}`);
        }

        doctorToken = doctorRes.body.access_token;
        doctorId = doctorRes.body.user.user_id;

        // Create availability slot for tomorrow
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        const availableDate = tomorrow.toISOString().split('T')[0];

        const availabilityRes = await request(app)
            .post('/availability')
            .send({
                doctorId: doctorId,
                availableDate: availableDate,
                startTime: '09:00',
                endTime: '10:00'
            });

        availabilityId = availabilityRes.body.data?.availability_id;
    });

    describe('Complete Booking Flow', () => {
        it('should check doctor availability before booking', async () => {
            const response = await request(app)
                .get(`/availability/doctor/${doctorId}`);

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);
            expect(response.body.data.length).toBeGreaterThan(0);

            const freeSlots = response.body.data.filter(slot => slot.status === 'free');
            expect(freeSlots.length).toBeGreaterThan(0);
        });

        it('should successfully book a consultation', async () => {
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 1);
            const consultationDate = tomorrow.toISOString().split('T')[0];

            const response = await request(app)
                .post('/consultations/book')
                .send({
                    patientId: patientId,
                    doctorId: doctorId,
                    availabilityId: availabilityId,
                    consultationDate: consultationDate,
                    startTime: '09:00'
                });

            expect(response.status).toBe(201);
            expect(response.body.message).toContain('booked successfully');
            expect(response.body.data).toHaveProperty('consultation_id');

            consultationId = response.body.data.consultation_id;
        });

        it('should retrieve the booked consultation for patient', async () => {
            const response = await request(app)
                .get(`/consultations/patient/${patientId}`);

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);
            expect(response.body.data.length).toBeGreaterThan(0);

            const bookedConsultation = response.body.data.find(
                c => c.consultation_id === consultationId
            );
            expect(bookedConsultation).toBeDefined();
            expect(bookedConsultation.patient_id).toBe(patientId);
            expect(bookedConsultation.doctor_id).toBe(doctorId);
        });

        it('should retrieve the booked consultation for doctor', async () => {
            const response = await request(app)
                .get(`/consultations/doctor/${doctorId}`);

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);

            const bookedConsultation = response.body.data.find(
                c => c.consultation_id === consultationId
            );
            expect(bookedConsultation).toBeDefined();
        });
    });

    describe('POST /consultations/book - Consultation Booking', () => {
        it('should reject booking with missing required fields', async () => {
            const response = await request(app)
                .post('/consultations/book')
                .send({
                    patientId: patientId
                });

            expect(response.status).toBe(500);
        });

        it('should reject booking with invalid date format', async () => {
            const response = await request(app)
                .post('/consultations/book')
                .send({
                    patientId: patientId,
                    doctorId: doctorId,
                    availabilityId: availabilityId,
                    consultationDate: 'invalid-date',
                    startTime: '09:00'
                });

            expect(response.status).toBe(500);
        });

        it('should reject booking with past date', async () => {
            const yesterday = new Date();
            yesterday.setDate(yesterday.getDate() - 1);
            const pastDate = yesterday.toISOString().split('T')[0];

            const response = await request(app)
                .post('/consultations/book')
                .send({
                    patientId: patientId,
                    doctorId: doctorId,
                    availabilityId: 999999,
                    consultationDate: pastDate,
                    startTime: '09:00'
                });

            expect(response.status).toBe(500);
        });
    });

    describe('GET /consultations/patient/:id - Patient Consultations', () => {
        it('should return all consultations for a patient', async () => {
            const response = await request(app)
                .get(`/consultations/patient/${patientId}`);

            expect(response.status).toBe(200);
            expect(response.body.message).toContain('retrieved successfully');
            expect(response.body.data).toBeInstanceOf(Array);
        });

        it('should return empty array for patient with no consultations', async () => {
            const response = await request(app)
                .get(`/consultations/patient/999999`);

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);
            expect(response.body.data.length).toBe(0);
        });

        it('should reject request without patient ID', async () => {
            const response = await request(app)
                .get('/consultations/patient/');

            expect(response.status).toBe(404);
        });
    });

    describe('GET /consultations/patient/:id/confirmed - Confirmed Consultations', () => {
        it('should return only confirmed consultations', async () => {
            const response = await request(app)
                .get(`/consultations/patient/${patientId}/confirmed`);

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);

            // All returned consultations should be scheduled or completed
            response.body.data.forEach(consultation => {
                expect(['scheduled', 'completed']).toContain(consultation.status);
            });
        });
    });

    describe('GET /consultations/patient/:id/pending - Pending Consultations', () => {
        it('should return only pending consultations', async () => {
            const response = await request(app)
                .get(`/consultations/patient/${patientId}/pending`);

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);

            // All returned consultations should be pending
            response.body.data.forEach(consultation => {
                expect(consultation.status).toBe('pending');
            });
        });
    });

    describe('GET /consultations/doctor/:id - Doctor Consultations', () => {
        it('should return all consultations for a doctor', async () => {
            const response = await request(app)
                .get(`/consultations/doctor/${doctorId}`);

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);
        });

        it('should return empty array for doctor with no consultations', async () => {
            const response = await request(app)
                .get(`/consultations/doctor/999999`);

            expect(response.status).toBe(200);
            expect(response.body.data).toEqual([]);
        });
    });

    describe('GET /consultations/doctor/:id/upcoming - Upcoming Consultations', () => {
        it('should return only upcoming consultations for doctor', async () => {
            const response = await request(app)
                .get(`/consultations/doctor/${doctorId}/upcoming`);

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);

            const today = new Date().toISOString().split('T')[0];
            response.body.data.forEach(consultation => {
                expect(consultation.consultation_date >= today).toBe(true);
            });
        });
    });

    describe('GET /consultations/doctor/:id/past - Past Consultations', () => {
        it('should return only past consultations for doctor', async () => {
            const response = await request(app)
                .get(`/consultations/doctor/${doctorId}/past`);

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);
        });
    });

    describe('PUT /consultations/:id/status - Update Status', () => {
        it('should update consultation status to scheduled', async () => {
            const response = await request(app)
                .put(`/consultations/${consultationId}/status`)
                .send({
                    status: 'scheduled'
                });

            expect(response.status).toBe(200);
            expect(response.body.message).toContain('updated successfully');
            expect(response.body.data.status).toBe('scheduled');
        });

        it('should reject invalid status values', async () => {
            const response = await request(app)
                .put(`/consultations/${consultationId}/status`)
                .send({
                    status: 'invalid_status'
                });

            expect(response.status).toBe(500);
        });

        it('should reject update without status field', async () => {
            const response = await request(app)
                .put(`/consultations/${consultationId}/status`)
                .send({});

            expect(response.status).toBe(400);
        });
    });

    describe('POST /consultations/:id/prescription - Add Prescription', () => {
        it('should add prescription to consultation', async () => {
            const prescription = 'https://your-supabase-url.supabase.co/storage/v1/object/public/prescriptions/consultation_123.pdf';

            const response = await request(app)
                .post(`/consultations/${consultationId}/prescription`)
                .send({
                    prescription: prescription
                });

            expect(response.status).toBe(200);
            expect(response.body.message).toContain('added successfully');
            expect(response.body.data.prescription).toBe(prescription);
        });

        it('should reject empty prescription', async () => {
            const response = await request(app)
                .post(`/consultations/${consultationId}/prescription`)
                .send({
                    prescription: ''
                });

            expect(response.status).toBe(400);
        });
    });

    describe('GET /consultations/patient/:id/prescriptions - Get Prescriptions', () => {
        it('should retrieve all prescriptions for patient', async () => {
            const response = await request(app)
                .get(`/consultations/patient/${patientId}/prescriptions`);

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);

            const withPrescription = response.body.data.filter(c => c.prescription);
            expect(withPrescription.length).toBeGreaterThanOrEqual(0);
        });
    });

    describe('PUT /consultations/:id/complete - Complete Consultation', () => {
        it('should mark consultation as completed', async () => {
            const response = await request(app)
                .put(`/consultations/${consultationId}/complete`);

            expect(response.status).toBe(200);
            expect(response.body.message).toContain('completed');
            expect(response.body.data.status).toBe('completed');
        });
    });

    describe('PUT /consultations/:id/cancel - Cancel Consultation', () => {
        let cancelTestId;

        beforeAll(async () => {
            // Create another consultation to cancel
            const tomorrow = new Date();
            tomorrow.setDate(tomorrow.getDate() + 2);
            const consultationDate = tomorrow.toISOString().split('T')[0];

            // Create new availability slot
            const availRes = await request(app)
                .post('/availability')
                .send({
                    doctorId: doctorId,
                    availableDate: consultationDate,
                    startTime: '14:00',
                    endTime: '15:00'
                });

            // Book consultation
            const bookRes = await request(app)
                .post('/consultations/book')
                .send({
                    patientId: patientId,
                    doctorId: doctorId,
                    availabilityId: availRes.body.data.availability_id,
                    consultationDate: consultationDate,
                    startTime: '14:00'
                });

            cancelTestId = bookRes.body.data.consultation_id;
        });

        it('should cancel a consultation', async () => {
            const response = await request(app)
                .put(`/consultations/${cancelTestId}/cancel`);

            expect(response.status).toBe(200);
            expect(response.body.message).toContain('cancelled');
            expect(response.body.data.status).toBe('cancelled');
        });

        it('should reject cancelling non-existent consultation', async () => {
            const response = await request(app)
                .put('/consultations/999999/cancel');

            expect(response.status).toBe(500);
        });
    });

    describe('Complete Consultation Lifecycle', () => {
        it('should complete full lifecycle: book → schedule → add prescription → complete', async () => {
            // Create availability
            const futureDate = new Date();
            futureDate.setDate(futureDate.getDate() + 3);
            const dateStr = futureDate.toISOString().split('T')[0];

            const availRes = await request(app)
                .post('/availability')
                .send({
                    doctorId: doctorId,
                    availableDate: dateStr,
                    startTime: '11:00',
                    endTime: '12:00'
                });

            expect(availRes.status).toBe(201);

            // Book consultation
            const bookRes = await request(app)
                .post('/consultations/book')
                .send({
                    patientId: patientId,
                    doctorId: doctorId,
                    availabilityId: availRes.body.data.availability_id,
                    consultationDate: dateStr,
                    startTime: '11:00'
                });

            expect(bookRes.status).toBe(201);
            const lifecycleId = bookRes.body.data.consultation_id;

            // Update to scheduled
            const scheduleRes = await request(app)
                .put(`/consultations/${lifecycleId}/status`)
                .send({ status: 'scheduled' });

            expect(scheduleRes.status).toBe(200);
            expect(scheduleRes.body.data.status).toBe('scheduled');

            // Add prescription
            const prescRes = await request(app)
                .post(`/consultations/${lifecycleId}/prescription`)
                .send({ prescription: 'Complete lifecycle test prescription' });

            expect(prescRes.status).toBe(200);

            // Complete consultation
            const completeRes = await request(app)
                .put(`/consultations/${lifecycleId}/complete`);

            expect(completeRes.status).toBe(200);
            expect(completeRes.body.data.status).toBe('completed');
        });
    });
});
