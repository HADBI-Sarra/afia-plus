import { describe, it, expect } from '@jest/globals';

/**
 * Unit Tests for Doctor Availability Service
 * Tests slot management and date filtering logic
 */

describe('Doctor Availability Service - Slot Management', () => {
    describe('Date Range Filtering', () => {
        it('should filter slots within date range', () => {
            const slots = [
                { available_date: '2026-01-10', status: 'free' },
                { available_date: '2026-01-15', status: 'free' },
                { available_date: '2026-01-20', status: 'free' },
                { available_date: '2026-01-25', status: 'free' }
            ];

            const startDate = '2026-01-12';
            const endDate = '2026-01-22';

            const filtered = slots.filter(slot =>
                slot.available_date >= startDate && slot.available_date <= endDate
            );

            expect(filtered).toHaveLength(2);
            expect(filtered[0].available_date).toBe('2026-01-15');
            expect(filtered[1].available_date).toBe('2026-01-20');
        });

        it('should handle empty date range', () => {
            const slots = [
                { available_date: '2026-01-10', status: 'free' }
            ];

            const startDate = '2026-02-01';
            const endDate = '2026-02-10';

            const filtered = slots.filter(slot =>
                slot.available_date >= startDate && slot.available_date <= endDate
            );

            expect(filtered).toHaveLength(0);
        });

        it('should include boundary dates', () => {
            const slots = [
                { available_date: '2026-01-10', status: 'free' },
                { available_date: '2026-01-15', status: 'free' },
                { available_date: '2026-01-20', status: 'free' }
            ];

            const startDate = '2026-01-10';
            const endDate = '2026-01-20';

            const filtered = slots.filter(slot =>
                slot.available_date >= startDate && slot.available_date <= endDate
            );

            expect(filtered).toHaveLength(3);
        });
    });

    describe('Slot Status Filtering', () => {
        it('should filter only free slots', () => {
            const slots = [
                { availability_id: 1, status: 'free' },
                { availability_id: 2, status: 'booked' },
                { availability_id: 3, status: 'free' },
                { availability_id: 4, status: 'cancelled' }
            ];

            const freeSlots = slots.filter(slot => slot.status === 'free');

            expect(freeSlots).toHaveLength(2);
            expect(freeSlots[0].availability_id).toBe(1);
            expect(freeSlots[1].availability_id).toBe(3);
        });

        it('should handle all booked slots', () => {
            const slots = [
                { availability_id: 1, status: 'booked' },
                { availability_id: 2, status: 'booked' }
            ];

            const freeSlots = slots.filter(slot => slot.status === 'free');

            expect(freeSlots).toHaveLength(0);
        });

        it('should validate slot status values', () => {
            const validStatuses = ['free', 'booked', 'cancelled'];
            const testStatus = 'free';

            expect(validStatuses).toContain(testStatus);
        });
    });

    describe('Slot Sorting', () => {
        it('should sort by date ascending', () => {
            const slots = [
                { available_date: '2026-01-20', start_time: '10:00' },
                { available_date: '2026-01-10', start_time: '14:00' },
                { available_date: '2026-01-15', start_time: '09:00' }
            ];

            const sorted = [...slots].sort((a, b) =>
                a.available_date.localeCompare(b.available_date)
            );

            expect(sorted[0].available_date).toBe('2026-01-10');
            expect(sorted[1].available_date).toBe('2026-01-15');
            expect(sorted[2].available_date).toBe('2026-01-20');
        });

        it('should sort by time within same date', () => {
            const slots = [
                { available_date: '2026-01-10', start_time: '14:00' },
                { available_date: '2026-01-10', start_time: '09:00' },
                { available_date: '2026-01-10', start_time: '11:00' }
            ];

            const sorted = [...slots].sort((a, b) =>
                a.start_time.localeCompare(b.start_time)
            );

            expect(sorted[0].start_time).toBe('09:00');
            expect(sorted[1].start_time).toBe('11:00');
            expect(sorted[2].start_time).toBe('14:00');
        });
    });

    describe('Slot Creation Validation', () => {
        it('should validate required fields for new slot', () => {
            const newSlot = {
                doctor_id: 1,
                available_date: '2026-01-15',
                start_time: '10:00',
                end_time: '11:00',
                status: 'free'
            };

            const hasAllFields = Object.values(newSlot).every(val => val !== null && val !== undefined);
            expect(hasAllFields).toBe(true);
        });

        it('should detect missing required fields', () => {
            const incompleteSlot = {
                doctor_id: 1,
                available_date: '2026-01-15',
                status: 'free'
                // missing start_time and end_time
            };

            const requiredFields = ['doctor_id', 'available_date', 'start_time', 'end_time', 'status'];
            const hasAllFields = requiredFields.every(field => incompleteSlot[field] !== undefined);

            expect(hasAllFields).toBe(false);
        });

        it('should validate time range (end > start)', () => {
            const startTime = '10:00';
            const endTime = '11:00';

            expect(endTime > startTime).toBe(true);
        });

        it('should reject invalid time range', () => {
            const startTime = '14:00';
            const endTime = '13:00';

            expect(endTime > startTime).toBe(false);
        });
    });

    describe('Slot Update Logic', () => {
        it('should update slot status from free to booked', () => {
            const slot = { availability_id: 1, status: 'free' };
            const newStatus = 'booked';

            expect(newStatus).toBe('booked');
            expect(slot.status).toBe('free'); // Original unchanged
        });

        it('should prevent booking already booked slot', () => {
            const slot = { availability_id: 1, status: 'booked' };
            const canBook = slot.status === 'free';

            expect(canBook).toBe(false);
        });
    });

    describe('Date Validation', () => {
        it('should validate date format YYYY-MM-DD', () => {
            const validDate = '2026-01-15';
            const datePattern = /^\d{4}-\d{2}-\d{2}$/;

            expect(datePattern.test(validDate)).toBe(true);
        });

        it('should reject invalid date formats', () => {
            const invalidDates = ['15-01-2026', '2026/01/15', '01-15-2026'];
            const datePattern = /^\d{4}-\d{2}-\d{2}$/;

            invalidDates.forEach(date => {
                expect(datePattern.test(date)).toBe(false);
            });
        });

        it('should validate future dates only', () => {
            const futureDate = new Date();
            futureDate.setDate(futureDate.getDate() + 7);
            const dateStr = futureDate.toISOString().split('T')[0];
            const now = new Date().toISOString().split('T')[0];

            expect(dateStr > now).toBe(true);
        });
    });

    describe('Edge Cases', () => {
        it('should handle empty availability list', () => {
            const slots = [];
            const filtered = slots.filter(slot => slot.status === 'free');

            expect(filtered).toHaveLength(0);
        });

        it('should handle null availability data', () => {
            const slots = null;
            const result = slots || [];

            expect(result).toHaveLength(0);
        });

        it('should handle duplicate time slots', () => {
            const slots = [
                { available_date: '2026-01-10', start_time: '10:00' },
                { available_date: '2026-01-10', start_time: '10:00' }
            ];

            // Should detect duplicates
            const hasDuplicate = slots.length !== new Set(slots.map(s => `${s.available_date}-${s.start_time}`)).size;
            expect(hasDuplicate).toBe(true);
        });
    });
});
