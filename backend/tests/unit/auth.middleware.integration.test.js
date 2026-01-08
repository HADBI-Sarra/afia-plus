import { describe, it, expect, jest, beforeEach, afterEach } from '@jest/globals';

// Mock Supabase BEFORE any imports
const mockGetUser = jest.fn();
jest.unstable_mockModule('../../src/config/supabase.js', () => ({
    supabaseAdmin: {
        auth: {
            getUser: mockGetUser
        }
    }
}));

// Now import the middleware (which will use the mocked supabase)
const { authMiddleware } = await import('../../middlewares/auth.middleware.js');

/**
 * Integration Tests for Auth Middleware
 * Tests actual middleware implementation with mocked Supabase
 */
describe('Auth Middleware - Integration Tests', () => {
    let mockReq;
    let mockRes;
    let mockNext;

    beforeEach(() => {
        // Reset all mocks
        mockGetUser.mockClear();

        // Setup mock request
        mockReq = {
            headers: {}
        };

        // Setup mock response
        mockRes = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis()
        };

        // Setup mock next
        mockNext = jest.fn();
    });

    describe('Token Validation', () => {
        it('should return 401 when no authorization header is present', async () => {
            await authMiddleware(mockReq, mockRes, mockNext);

            expect(mockRes.status).toHaveBeenCalledWith(401);
            expect(mockRes.json).toHaveBeenCalledWith({ message: 'Missing token' });
            expect(mockNext).not.toHaveBeenCalled();
        });

        it('should return 401 when token is empty', async () => {
            mockReq.headers.authorization = 'Bearer ';

            await authMiddleware(mockReq, mockRes, mockNext);

            expect(mockRes.status).toHaveBeenCalledWith(401);
            expect(mockRes.json).toHaveBeenCalledWith({ message: 'Missing token' });
            expect(mockNext).not.toHaveBeenCalled();
        });

        it('should extract token correctly from Bearer header', async () => {
            const testToken = 'test-jwt-token-123';
            mockReq.headers.authorization = `Bearer ${testToken}`;

            mockGetUser.mockResolvedValue({
                data: {
                    user: {
                        id: '123e4567-e89b-12d3-a456-426614174000',
                        email: 'test@example.com'
                    }
                },
                error: null
            });

            await authMiddleware(mockReq, mockRes, mockNext);

            expect(mockGetUser).toHaveBeenCalledWith(testToken);
        });

        it('should return 401 when Supabase returns error', async () => {
            mockReq.headers.authorization = 'Bearer invalid-token';

            mockGetUser.mockResolvedValue({
                data: { user: null },
                error: { message: 'Invalid JWT' }
            });

            await authMiddleware(mockReq, mockRes, mockNext);

            expect(mockRes.status).toHaveBeenCalledWith(401);
            expect(mockRes.json).toHaveBeenCalledWith({ message: 'Invalid token' });
            expect(mockNext).not.toHaveBeenCalled();
        });

        it('should return 401 when user is null', async () => {
            mockReq.headers.authorization = 'Bearer valid-token';

            mockGetUser.mockResolvedValue({
                data: { user: null },
                error: null
            });

            await authMiddleware(mockReq, mockRes, mockNext);

            expect(mockRes.status).toHaveBeenCalledWith(401);
            expect(mockRes.json).toHaveBeenCalledWith({ message: 'Invalid token' });
            expect(mockNext).not.toHaveBeenCalled();
        });
    });

    describe('Successful Authentication', () => {
        it('should attach user to request and call next on valid token', async () => {
            const mockUser = {
                id: '123e4567-e89b-12d3-a456-426614174000',
                email: 'user@example.com',
                role: 'patient'
            };

            mockReq.headers.authorization = 'Bearer valid-token';

            mockGetUser.mockResolvedValue({
                data: { user: mockUser },
                error: null
            });

            await authMiddleware(mockReq, mockRes, mockNext);

            expect(mockReq.user).toEqual(mockUser);
            expect(mockNext).toHaveBeenCalledTimes(1);
            expect(mockRes.status).not.toHaveBeenCalled();
            expect(mockRes.json).not.toHaveBeenCalled();
        });

        it('should preserve user UUID format', async () => {
            const mockUser = {
                id: '550e8400-e29b-41d4-a716-446655440000',
                email: 'doctor@example.com'
            };

            mockReq.headers.authorization = 'Bearer valid-token';

            mockGetUser.mockResolvedValue({
                data: { user: mockUser },
                error: null
            });

            await authMiddleware(mockReq, mockRes, mockNext);

            expect(mockReq.user.id).toMatch(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/);
        });

        it('should handle user with all standard fields', async () => {
            const mockUser = {
                id: '123e4567-e89b-12d3-a456-426614174000',
                email: 'complete@example.com',
                phone: '+1234567890',
                email_confirmed_at: '2026-01-01T00:00:00Z',
                created_at: '2026-01-01T00:00:00Z'
            };

            mockReq.headers.authorization = 'Bearer valid-token';

            mockGetUser.mockResolvedValue({
                data: { user: mockUser },
                error: null
            });

            await authMiddleware(mockReq, mockRes, mockNext);

            expect(mockReq.user).toHaveProperty('id');
            expect(mockReq.user).toHaveProperty('email');
            expect(mockReq.user).toHaveProperty('phone');
        });
    });

    describe('Edge Cases', () => {
        it('should handle malformed authorization header', async () => {
            mockReq.headers.authorization = 'InvalidFormat token123';

            mockGetUser.mockResolvedValue({
                data: { user: null },
                error: { message: 'Invalid token format' }
            });

            await authMiddleware(mockReq, mockRes, mockNext);

            expect(mockNext).not.toHaveBeenCalled();
        });

        it('should handle Supabase connection error', async () => {
            mockReq.headers.authorization = 'Bearer valid-token';

            mockGetUser.mockResolvedValue({
                data: { user: null },
                error: { message: 'Network error' }
            });

            await authMiddleware(mockReq, mockRes, mockNext);

            expect(mockRes.status).toHaveBeenCalledWith(401);
            expect(mockNext).not.toHaveBeenCalled();
        });

        it('should handle undefined authorization header', async () => {
            mockReq.headers.authorization = undefined;

            await authMiddleware(mockReq, mockRes, mockNext);

            expect(mockRes.status).toHaveBeenCalledWith(401);
            expect(mockRes.json).toHaveBeenCalledWith({ message: 'Missing token' });
        });

        it('should handle authorization header without Bearer prefix', async () => {
            mockReq.headers.authorization = 'just-a-token';

            mockGetUser.mockResolvedValue({
                data: {
                    user: {
                        id: '123e4567-e89b-12d3-a456-426614174000',
                        email: 'test@example.com'
                    }
                },
                error: null
            });

            await authMiddleware(mockReq, mockRes, mockNext);

            // Token will be 'just-a-token' after replace attempt
            expect(mockGetUser).toHaveBeenCalledWith('just-a-token');
        });
    });

    describe('Security', () => {
        it('should not expose token in response', async () => {
            mockReq.headers.authorization = 'Bearer secret-token';

            mockGetUser.mockResolvedValue({
                data: { user: null },
                error: { message: 'Invalid' }
            });

            await authMiddleware(mockReq, mockRes, mockNext);

            const jsonCall = mockRes.json.mock.calls[0][0];
            expect(JSON.stringify(jsonCall)).not.toContain('secret-token');
        });

        it('should not leak Supabase error details to client', async () => {
            mockReq.headers.authorization = 'Bearer token';

            mockGetUser.mockResolvedValue({
                data: { user: null },
                error: { message: 'Internal Supabase error with sensitive info' }
            });

            await authMiddleware(mockReq, mockRes, mockNext);

            const jsonCall = mockRes.json.mock.calls[0][0];
            expect(jsonCall.message).toBe('Invalid token');
            expect(jsonCall.message).not.toContain('Supabase');
        });
    });
});
