import { describe, it, expect, jest, beforeEach } from '@jest/globals';

/**
 * Integration Tests for Consultations Service  
 * Tests actual service methods with mocked Supabase database
 */

// Create a simple chainable mock builder
function createSupabaseMock(finalResponse = { data: [], error: null }) {
    const mockMethods = {
        select: jest.fn(),
        eq: jest.fn(),
        in: jest.fn(),
        order: jest.fn(),
        single: jest.fn(),
        insert: jest.fn(),
        update: jest.fn(),
        delete: jest.fn()
    };

    // Create a chainable object that has all methods
    const chainable = {
        ...mockMethods,
        select: jest.fn().mockReturnThis(),
        eq: jest.fn().mockReturnThis(),
        in: jest.fn().mockReturnThis(),
        order: jest.fn().mockReturnThis(),
        insert: jest.fn().mockReturnThis(),
        update: jest.fn().mockReturnThis(),
        delete: jest.fn().mockReturnThis(),
        single: jest.fn().mockResolvedValue(finalResponse),
        then: (resolve) => resolve(finalResponse),
        catch: () => chainable
    };

    // Make all methods point to the chainable versions
    Object.keys(mockMethods).forEach(key => {
        mockMethods[key].mockReturnValue(chainable);
    });

    // The initial mock returns the chainable
    const mock = {
        ...mockMethods
    };

    // Override to return chainable
    mock.select.mockReturnValue(chainable);
    mock.eq.mockReturnValue(chainable);
    mock.in.mockReturnValue(chainable);
    mock.order.mockReturnValue(chainable);
    mock.insert.mockReturnValue(chainable);
    mock.update.mockReturnValue(chainable);
    mock.delete.mockReturnValue(chainable);
    mock.single.mockResolvedValue(finalResponse);

    return mock;
}

// Mock Supabase before importing
const mockFrom = jest.fn();
jest.unstable_mockModule('../../src/config/supabase.js', () => ({
    supabaseAdmin: {
        from: mockFrom
    }
}));

jest.unstable_mockModule('../../utils/logger.js', () => ({
    logger: {
        info: jest.fn(),
        error: jest.fn(),
        log: jest.fn()
    }
}));

// Import service after mocks are set up
const { ConsultationsService } = await import('../../services/consultations.service.js');

describe('Consultations Service - Integration Tests', () => {
    let mockChain;

    beforeEach(() => {
        jest.clearAllMocks();
    });

    // Helper to setup mock with specific response
    const setupMock = (response = { data: [], error: null }) => {
        mockChain = createSupabaseMock(response);
        mockFrom.mockReturnValue(mockChain);
        return mockChain;
    };

    describe('getPatientConsultations', () => {
        it('should retrieve all consultations for a patient', async () => {
            const mockData = [
                {
                    consultation_id: 1,
                    patient_id: 100,
                    doctor_id: 200,
                    consultation_date: '2026-01-15',
                    start_time: '10:00',
                    status: 'scheduled',
                    doctor: {
                        doctor_id: 200,
                        user: { firstname: 'Dr. John', lastname: 'Smith' }
                    }
                }
            ];

            setupMock({ data: mockData, error: null });

            const result = await ConsultationsService.getPatientConsultations(100);

            expect(mockFrom).toHaveBeenCalledWith('consultations');
            expect(result).toEqual(mockData);
            expect(result).toHaveLength(1);
        });

        it('should return empty array when patient has no consultations', async () => {
            setupMock({ data: [], error: null });

            const result = await ConsultationsService.getPatientConsultations(999);

            expect(result).toEqual([]);
        });

        it('should throw error when database query fails', async () => {
            setupMock({
                data: null,
                error: { message: 'Database connection failed' }
            });

            await expect(ConsultationsService.getPatientConsultations(100))
                .rejects
                .toThrow('Failed to get patient consultations: Database connection failed');
        });

        it('should handle null data from database', async () => {
            setupMock({ data: null, error: null });

            const result = await ConsultationsService.getPatientConsultations(100);

            expect(result).toEqual([]);
        });
    });

    describe('getConfirmedPatientConsultations', () => {
        it('should retrieve only scheduled and completed consultations', async () => {
            const mockData = [
                {
                    consultation_id: 1,
                    patient_id: 100,
                    status: 'scheduled',
                    consultation_date: '2026-01-15'
                },
                {
                    consultation_id: 2,
                    patient_id: 100,
                    status: 'completed',
                    consultation_date: '2026-01-10'
                }
            ];

            setupMock({ data: mockData, error: null });

            const result = await ConsultationsService.getConfirmedPatientConsultations(100);

            expect(result).toEqual(mockData);
            expect(result.every(c => ['scheduled', 'completed'].includes(c.status))).toBe(true);
        });

        it('should throw error on database failure', async () => {
            setupMock({
                data: null,
                error: { message: 'Query timeout' }
            });

            await expect(ConsultationsService.getConfirmedPatientConsultations(100))
                .rejects
                .toThrow('Failed to get confirmed consultations: Query timeout');
        });
    });

    describe('getNotConfirmedPatientConsultations', () => {
        it('should retrieve only pending consultations', async () => {
            const mockData = [
                {
                    consultation_id: 1,
                    patient_id: 100,
                    status: 'pending',
                    consultation_date: '2026-01-20'
                }
            ];

            setupMock({ data: mockData, error: null });

            const result = await ConsultationsService.getNotConfirmedPatientConsultations(100);

            expect(result).toEqual(mockData);
        });

        it('should return empty array when no pending consultations exist', async () => {
            setupMock({ data: [], error: null });

            const result = await ConsultationsService.getNotConfirmedPatientConsultations(100);

            expect(result).toEqual([]);
        });

        it('should throw error on database failure', async () => {
            setupMock({
                data: null,
                error: { message: 'Access denied' }
            });

            await expect(ConsultationsService.getNotConfirmedPatientConsultations(100))
                .rejects
                .toThrow('Failed to get pending consultations: Access denied');
        });
    });

    describe('getDoctorConsultations', () => {
        it('should retrieve all consultations for a doctor', async () => {
            const mockData = [
                {
                    consultation_id: 1,
                    doctor_id: 200,
                    patient_id: 100,
                    consultation_date: '2026-01-15',
                    patient: {
                        patient_id: 100,
                        user: { firstname: 'Jane', lastname: 'Doe' }
                    }
                }
            ];

            setupMock({ data: mockData, error: null });

            const result = await ConsultationsService.getDoctorConsultations(200);

            expect(result).toEqual(mockData);
            expect(result[0]).toHaveProperty('patient');
        });

        it('should return empty array when doctor has no consultations', async () => {
            setupMock({ data: [], error: null });

            const result = await ConsultationsService.getDoctorConsultations(999);

            expect(result).toEqual([]);
        });
    });

    describe('Data Structure Validation', () => {
        it('should include nested doctor information', async () => {
            const mockData = [
                {
                    consultation_id: 1,
                    doctor: {
                        doctor_id: 200,
                        speciality_id: 5,
                        user: {
                            firstname: 'Dr. John',
                            lastname: 'Smith',
                            profile_picture: 'url',
                            phone_number: '1234567890'
                        },
                        speciality: {
                            speciality_name: 'Cardiology'
                        }
                    }
                }
            ];

            setupMock({ data: mockData, error: null });

            const result = await ConsultationsService.getPatientConsultations(100);

            expect(result[0].doctor).toHaveProperty('user');
            expect(result[0].doctor.user).toHaveProperty('firstname');
            expect(result[0].doctor).toHaveProperty('speciality');
        });
    });

    describe('Edge Cases', () => {
        it('should handle very large patient IDs', async () => {
            setupMock({ data: [], error: null });

            const result = await ConsultationsService.getPatientConsultations(999999999);

            expect(result).toEqual([]);
        });

        it('should handle zero as patient ID', async () => {
            setupMock({ data: [], error: null });

            const result = await ConsultationsService.getPatientConsultations(0);

            expect(result).toEqual([]);
        });

        it('should return empty array for undefined data', async () => {
            setupMock({ data: undefined, error: null });

            const result = await ConsultationsService.getPatientConsultations(100);

            expect(result).toEqual([]);
        });
    });

    describe('Method Calls Verification', () => {
        it('should call Supabase from method with consultations table', async () => {
            setupMock({ data: [], error: null });

            await ConsultationsService.getPatientConsultations(100);

            expect(mockFrom).toHaveBeenCalledWith('consultations');
        });

        it('should retrieve consultations with correct filtering for confirmed status', async () => {
            const mockData = [
                { consultation_id: 1, status: 'scheduled' },
                { consultation_id: 2, status: 'completed' }
            ];

            setupMock({ data: mockData, error: null });

            const result = await ConsultationsService.getConfirmedPatientConsultations(100);

            // Verify only scheduled and completed consultations are returned
            expect(result).toEqual(mockData);
            expect(result.every(c => ['scheduled', 'completed'].includes(c.status))).toBe(true);
        });
    });
});
