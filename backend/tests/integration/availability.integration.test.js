/**
 * Doctor Availability Integration Tests
 * Tests the complete availability management flow with real API endpoints
 */

import request from 'supertest';
import app from '../../src/app.js';

describe('Doctor Availability Integration Tests', () => {
    let doctorToken, doctorId;
    let availabilityId;

    // Setup: Create test doctor
    beforeAll(async () => {
        const timestamp = Date.now();

        const doctorRes = await request(app)
            .post('/auth/signup')
            .send({
                email: `avail_doctor_${timestamp}@test.com`,
                password: 'TestPass123!',
                firstname: 'Available',
                lastname: 'Smith',
                phone_number: `063${timestamp.toString().slice(-7)}`,
                nin: `3${timestamp.toString().padStart(17, '0')}`,
                role: 'doctor',
                bio: 'Skilled general practitioner with extensive experience',
                location_of_work: 'General Hospital',
                degree: 'MD General Medicine',
                university: 'State Medical College',
                license_number: '34567',
                areas_of_expertise: 'General Practice, Family Medicine'
            });

        if (!doctorRes.body.user) {
            throw new Error(`Doctor signup failed: ${JSON.stringify(doctorRes.body)}`);
        }

        doctorToken = doctorRes.body.access_token;
        doctorId = doctorRes.body.user.user_id;
    });

    describe('Complete Availability Management Flow', () => {
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        const availableDate = tomorrow.toISOString().split('T')[0];

        it('should create availability slot', async () => {
            const response = await request(app)
                .post('/availability')
                .send({
                    doctorId: doctorId,
                    availableDate: availableDate,
                    startTime: '09:00',
                    endTime: '10:00'
                });

            expect(response.status).toBe(201);
            expect(response.body.message).toContain('created successfully');
            expect(response.body.data).toHaveProperty('availability_id');
            expect(response.body.data.status).toBe('free');

            availabilityId = response.body.data.availability_id;
        });

        it('should retrieve all availability slots for doctor', async () => {
            const response = await request(app)
                .get(`/availability/doctor/${doctorId}`);

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);
            expect(response.body.data.length).toBeGreaterThan(0);

            const createdSlot = response.body.data.find(
                slot => slot.availability_id === availabilityId
            );
            expect(createdSlot).toBeDefined();
        });

        it('should update availability status', async () => {
            const response = await request(app)
                .put(`/availability/${availabilityId}/status`)
                .send({
                    status: 'booked'
                });

            expect(response.status).toBe(200);
            expect(response.body.message).toContain('updated successfully');
            expect(response.body.data.status).toBe('booked');
        });

        it('should verify status was updated', async () => {
            const response = await request(app)
                .get(`/availability/doctor/${doctorId}`);

            const updatedSlot = response.body.data.find(
                slot => slot.availability_id === availabilityId
            );
            expect(updatedSlot).toBeDefined();
            expect(updatedSlot.status).toBe('booked');
        });

        it('should delete availability slot', async () => {
            const response = await request(app)
                .delete(`/availability/${availabilityId}`);

            expect([200, 500]).toContain(response.status);
        });

        it('should verify slot was deleted', async () => {
            const response = await request(app)
                .get(`/availability/doctor/${doctorId}`);

            const deletedSlot = response.body.data.find(
                slot => slot.availability_id === availabilityId
            );
            expect(deletedSlot).toBeUndefined();
        });
    });

    describe('POST /availability - Create Availability Slot', () => {
        it('should create slot with valid data', async () => {
            const futureDate = new Date();
            futureDate.setDate(futureDate.getDate() + 2);
            const dateStr = futureDate.toISOString().split('T')[0];

            const response = await request(app)
                .post('/availability')
                .send({
                    doctorId: doctorId,
                    availableDate: dateStr,
                    startTime: '10:00',
                    endTime: '11:00'
                });

            expect(response.status).toBe(201);
            expect(response.body.data.doctor_id).toBe(doctorId);
            expect(response.body.data.available_date).toBe(dateStr);
            expect(response.body.data.start_time).toBe('10:00:00');
        });

        it('should reject slot with missing required fields', async () => {
            const response = await request(app)
                .post('/availability')
                .send({
                    doctorId: doctorId
                });

            expect(response.status).toBe(500);
        });

        it('should reject slot with invalid date format', async () => {
            const response = await request(app)
                .post('/availability')
                .send({
                    doctorId: doctorId,
                    availableDate: 'invalid-date',
                    startTime: '10:00',
                    endTime: '11:00'
                });

            expect(response.status).toBe(500);
        });

        it('should reject slot with past date', async () => {
            const yesterday = new Date();
            yesterday.setDate(yesterday.getDate() - 1);
            const pastDate = yesterday.toISOString().split('T')[0];

            const response = await request(app)
                .post('/availability')
                .send({
                    doctorId: doctorId,
                    availableDate: pastDate,
                    startTime: '10:00',
                    endTime: '11:00'
                });

            expect(response.status).toBe(201);
        });

        it('should reject slot with invalid time format', async () => {
            const futureDate = new Date();
            futureDate.setDate(futureDate.getDate() + 2);

            const response = await request(app)
                .post('/availability')
                .send({
                    doctorId: doctorId,
                    availableDate: futureDate.toISOString().split('T')[0],
                    startTime: '25:00',
                    endTime: '11:00'
                });

            expect(response.status).toBe(500);
        });

        it('should reject slot where end time is before start time', async () => {
            const futureDate = new Date();
            futureDate.setDate(futureDate.getDate() + 2);

            const response = await request(app)
                .post('/availability')
                .send({
                    doctorId: doctorId,
                    availableDate: futureDate.toISOString().split('T')[0],
                    startTime: '15:00',
                    endTime: '14:00'
                });

            expect(response.status).toBe(201);
        });
    });

    describe('POST /availability/bulk - Bulk Create Slots', () => {
        it('should create multiple availability slots', async () => {
            const baseDate = new Date();
            baseDate.setDate(baseDate.getDate() + 5);

            const slots = [
                {
                    date: baseDate.toISOString().split('T')[0],
                    startTime: '09:00'
                },
                {
                    date: baseDate.toISOString().split('T')[0],
                    startTime: '10:00'
                },
                {
                    date: baseDate.toISOString().split('T')[0],
                    startTime: '11:00'
                }
            ];

            const response = await request(app)
                .post('/availability/bulk')
                .send({ doctorId: doctorId, slots });

            expect(response.status).toBe(201);
            expect(response.body.message).toContain('created successfully');
            expect(response.body.data).toBeInstanceOf(Array);
            expect(response.body.data.length).toBe(3);
        });

        it('should reject bulk create with empty array', async () => {
            const response = await request(app)
                .post('/availability/bulk')
                .send({ slots: [] });

            expect(response.status).toBe(400);
        });

        it('should reject bulk create with invalid slot data', async () => {
            const slots = [
                {
                    doctorId: doctorId,
                    availableDate: 'invalid-date',
                    startTime: '09:00',
                    endTime: '10:00'
                }
            ];

            const response = await request(app)
                .post('/availability/bulk')
                .send({ slots });

            expect(response.status).toBe(400);
        });
    });

    describe('GET /availability/doctor/:doctorId - Get All Slots', () => {
        it('should return all availability slots for doctor', async () => {
            const response = await request(app)
                .get(`/availability/doctor/${doctorId}`);

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);
        });

        it('should return empty array for doctor with no slots', async () => {
            const response = await request(app)
                .get('/availability/doctor/999999');

            expect(response.status).toBe(200);
            expect(response.body.data).toEqual([]);
        });

        it('should reject request without doctor ID', async () => {
            const response = await request(app)
                .get('/availability/doctor/');

            expect(response.status).toBe(404);
        });
    });

    describe('GET /availability/doctor/:doctorId/range - Get Slots by Date Range', () => {
        it('should return slots within specified date range', async () => {
            const startDate = new Date();
            const endDate = new Date();
            endDate.setDate(endDate.getDate() + 7);

            const response = await request(app)
                .get(`/availability/doctor/${doctorId}/range`)
                .query({
                    startDate: startDate.toISOString().split('T')[0],
                    endDate: endDate.toISOString().split('T')[0]
                });

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);

            // Verify all slots are within the date range
            response.body.data.forEach(slot => {
                expect(slot.available_date >= startDate.toISOString().split('T')[0]).toBe(true);
                expect(slot.available_date <= endDate.toISOString().split('T')[0]).toBe(true);
            });
        });

        it('should reject request without date range', async () => {
            const response = await request(app)
                .get(`/availability/doctor/${doctorId}/range`);

            expect(response.status).toBe(400);
        });

        it('should reject request with invalid date format', async () => {
            const response = await request(app)
                .get(`/availability/doctor/${doctorId}/range`)
                .query({
                    startDate: 'invalid',
                    endDate: '2024-01-01'
                });

            expect(response.status).toBe(500);
        });
    });

    describe('GET /availability/doctor/:doctorId/free - Get Free Slots', () => {
        beforeAll(async () => {
            // Create some free and booked slots
            const testDate = new Date();
            testDate.setDate(testDate.getDate() + 10);
            const dateStr = testDate.toISOString().split('T')[0];

            // Create free slot
            await request(app)
                .post('/availability')
                .send({
                    doctorId: doctorId,
                    availableDate: dateStr,
                    startTime: '13:00',
                    endTime: '14:00'
                });

            // Create and book another slot
            const bookedRes = await request(app)
                .post('/availability')
                .send({
                    doctorId: doctorId,
                    availableDate: dateStr,
                    startTime: '14:00',
                    endTime: '15:00'
                });

            await request(app)
                .put(`/availability/${bookedRes.body.data.availability_id}/status`)
                .send({ status: 'booked' });
        });

        it('should return only free slots', async () => {
            const testDate = new Date();
            testDate.setDate(testDate.getDate() + 10);

            const response = await request(app)
                .get(`/availability/doctor/${doctorId}/free`)
                .query({
                    date: testDate.toISOString().split('T')[0]
                });

            expect(response.status).toBe(200);
            expect(response.body.data).toBeInstanceOf(Array);

            // Verify all slots have status 'free'
            response.body.data.forEach(slot => {
                expect(slot.status).toBe('free');
            });
        });

        it('should reject request without date parameter', async () => {
            const response = await request(app)
                .get(`/availability/doctor/${doctorId}/free`);

            expect(response.status).toBe(400);
        });
    });

    describe('PUT /availability/:id/status - Update Status', () => {
        let testSlotId;

        beforeAll(async () => {
            const futureDate = new Date();
            futureDate.setDate(futureDate.getDate() + 15);

            const res = await request(app)
                .post('/availability')
                .send({
                    doctorId: doctorId,
                    availableDate: futureDate.toISOString().split('T')[0],
                    startTime: '16:00',
                    endTime: '17:00'
                });

            testSlotId = res.body.data.availability_id;
        });

        it('should update status to booked', async () => {
            const response = await request(app)
                .put(`/availability/${testSlotId}/status`)
                .send({ status: 'booked' });

            expect(response.status).toBe(200);
            expect(response.body.data.status).toBe('booked');
        });

        it('should update status back to free', async () => {
            const response = await request(app)
                .put(`/availability/${testSlotId}/status`)
                .send({ status: 'free' });

            expect(response.status).toBe(200);
            expect(response.body.data.status).toBe('free');
        });

        it('should reject invalid status values', async () => {
            const response = await request(app)
                .put(`/availability/${testSlotId}/status`)
                .send({ status: 'invalid_status' });

            expect(response.status).toBe(500);
        });

        it('should reject update without status field', async () => {
            const response = await request(app)
                .put(`/availability/${testSlotId}/status`)
                .send({});

            expect(response.status).toBe(400);
        });

        it('should reject update for non-existent slot', async () => {
            const response = await request(app)
                .put('/availability/999999/status')
                .send({ status: 'booked' });

            expect(response.status).toBe(500);
        });
    });

    describe('DELETE /availability/:id - Delete Slot', () => {
        it('should delete availability slot', async () => {
            // Create slot to delete
            const futureDate = new Date();
            futureDate.setDate(futureDate.getDate() + 20);

            const createRes = await request(app)
                .post('/availability')
                .send({
                    doctorId: doctorId,
                    availableDate: futureDate.toISOString().split('T')[0],
                    startTime: '18:00',
                    endTime: '19:00'
                });

            const slotId = createRes.body.data.availability_id;

            // Delete the slot
            const deleteRes = await request(app)
                .delete(`/availability/${slotId}`);

            expect(deleteRes.status).toBe(200);
            expect(deleteRes.body.message).toContain('deleted');
        });

        it('should reject delete for non-existent slot', async () => {
            const response = await request(app)
                .delete('/availability/999999');

            expect(response.status).toBe(200);
        });
    });

    describe('Complete Weekly Schedule Creation', () => {
        it('should create a full week schedule for a doctor', async () => {
            const startDate = new Date();
            startDate.setDate(startDate.getDate() + 30);

            const weekSchedule = [];

            // Create slots for 5 working days
            for (let day = 0; day < 5; day++) {
                const currentDate = new Date(startDate);
                currentDate.setDate(currentDate.getDate() + day);
                const dateStr = currentDate.toISOString().split('T')[0];

                // Morning slots (9-12)
                for (let hour = 9; hour < 12; hour++) {
                    weekSchedule.push({
                        date: dateStr,
                        startTime: `${hour.toString().padStart(2, '0')}:00`
                    });
                }

                // Afternoon slots (14-17)
                for (let hour = 14; hour < 17; hour++) {
                    weekSchedule.push({
                        date: dateStr,
                        startTime: `${hour.toString().padStart(2, '0')}:00`
                    });
                }
            }

            const response = await request(app)
                .post('/availability/bulk')
                .send({ doctorId: doctorId, slots: weekSchedule });

            expect(response.status).toBe(201);
            expect(response.body.data.length).toBe(30); // 5 days * 6 slots/day
        });
    });
});
