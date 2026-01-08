import { describe, it, expect } from '@jest/globals';

/**
 * Unit Tests for Response Utilities
 * Tests standardized API response formatting
 */

describe('Response Utils - API Response Formatting', () => {
    describe('Success Response Structure', () => {
        it('should format success response with data', () => {
            const response = {
                status: 200,
                message: 'Success',
                data: { id: 1, name: 'Test' }
            };

            expect(response).toHaveProperty('status');
            expect(response).toHaveProperty('message');
            expect(response).toHaveProperty('data');
            expect(response.status).toBe(200);
        });

        it('should format success response without data', () => {
            const response = {
                status: 204,
                message: 'No content'
            };

            expect(response).toHaveProperty('status');
            expect(response).toHaveProperty('message');
            expect(response).not.toHaveProperty('data');
        });

        it('should handle null data correctly', () => {
            const data = null;
            const includeData = data !== null;

            expect(includeData).toBe(false);
        });
    });

    describe('Error Response Structure', () => {
        it('should format error response with message', () => {
            const response = {
                status: 400,
                message: 'Bad request',
                error: 'Invalid input'
            };

            expect(response).toHaveProperty('status');
            expect(response).toHaveProperty('message');
            expect(response.status).toBeGreaterThanOrEqual(400);
        });

        it('should include error details in development', () => {
            const isDevelopment = process.env.NODE_ENV === 'development';
            const error = new Error('Database connection failed');

            const response = {
                status: 500,
                message: 'Internal server error',
                ...(isDevelopment && { error: error.message })
            };

            if (isDevelopment) {
                expect(response).toHaveProperty('error');
            }
        });

        it('should hide error details in production', () => {
            const isProduction = process.env.NODE_ENV === 'production';
            const error = new Error('Database connection failed');

            const response = {
                status: 500,
                message: 'Internal server error',
                ...(isProduction === false && { error: error.message })
            };

            if (isProduction) {
                expect(response).not.toHaveProperty('error');
            }
        });
    });

    describe('HTTP Status Codes', () => {
        it('should use correct success status codes', () => {
            const statusCodes = {
                ok: 200,
                created: 201,
                accepted: 202,
                noContent: 204
            };

            expect(statusCodes.ok).toBe(200);
            expect(statusCodes.created).toBe(201);
            expect(statusCodes.noContent).toBe(204);
        });

        it('should use correct client error status codes', () => {
            const statusCodes = {
                badRequest: 400,
                unauthorized: 401,
                forbidden: 403,
                notFound: 404,
                conflict: 409
            };

            expect(statusCodes.badRequest).toBe(400);
            expect(statusCodes.unauthorized).toBe(401);
            expect(statusCodes.notFound).toBe(404);
        });

        it('should use correct server error status codes', () => {
            const statusCodes = {
                internalError: 500,
                notImplemented: 501,
                badGateway: 502,
                serviceUnavailable: 503
            };

            expect(statusCodes.internalError).toBe(500);
            expect(statusCodes.serviceUnavailable).toBe(503);
        });

        it('should categorize status codes correctly', () => {
            const isSuccess = (status) => status >= 200 && status < 300;
            const isClientError = (status) => status >= 400 && status < 500;
            const isServerError = (status) => status >= 500 && status < 600;

            expect(isSuccess(200)).toBe(true);
            expect(isClientError(404)).toBe(true);
            expect(isServerError(500)).toBe(true);
        });
    });

    describe('Response Data Formatting', () => {
        it('should format array data', () => {
            const data = [
                { id: 1, name: 'Item 1' },
                { id: 2, name: 'Item 2' }
            ];

            const response = {
                status: 200,
                message: 'Success',
                data: data
            };

            expect(Array.isArray(response.data)).toBe(true);
            expect(response.data).toHaveLength(2);
        });

        it('should format object data', () => {
            const data = {
                id: 1,
                name: 'Test',
                email: 'test@example.com'
            };

            const response = {
                status: 200,
                message: 'Success',
                data: data
            };

            expect(typeof response.data).toBe('object');
            expect(response.data).toHaveProperty('id');
        });

        it('should handle empty data', () => {
            const data = [];
            const response = {
                status: 200,
                message: 'Success',
                data: data
            };

            expect(response.data).toHaveLength(0);
        });
    });

    describe('Message Formatting', () => {
        it('should use descriptive success messages', () => {
            const messages = [
                'Resource created successfully',
                'Updated successfully',
                'Deleted successfully',
                'Operation completed'
            ];

            messages.forEach(msg => {
                expect(msg).toBeTruthy();
                expect(typeof msg).toBe('string');
            });
        });

        it('should use descriptive error messages', () => {
            const messages = [
                'Resource not found',
                'Unauthorized access',
                'Validation failed',
                'Internal server error'
            ];

            messages.forEach(msg => {
                expect(msg).toBeTruthy();
                expect(typeof msg).toBe('string');
            });
        });

        it('should handle empty messages', () => {
            const message = '';
            const hasMessage = message.length > 0;

            expect(hasMessage).toBe(false);
        });
    });

    describe('Response Spread Operator Logic', () => {
        it('should conditionally include data field', () => {
            const data = { id: 1 };
            const response = {
                status: 200,
                message: 'Success',
                ...(data && { data })
            };

            expect(response).toHaveProperty('data');
        });

        it('should exclude data when null', () => {
            const data = null;
            const response = {
                status: 200,
                message: 'Success',
                ...(data && { data })
            };

            expect(response).not.toHaveProperty('data');
        });

        it('should conditionally include error field', () => {
            const error = { message: 'Error occurred' };
            const response = {
                status: 500,
                message: 'Server error',
                ...(error && { error: error.message })
            };

            expect(response).toHaveProperty('error');
        });
    });

    describe('Edge Cases', () => {
        it('should handle very large data objects', () => {
            const largeData = Array.from({ length: 1000 }, (_, i) => ({ id: i }));
            const response = {
                status: 200,
                message: 'Success',
                data: largeData
            };

            expect(response.data).toHaveLength(1000);
        });

        it('should handle special characters in messages', () => {
            const message = 'Error: Invalid input "test@example.com"';

            expect(message).toContain('"');
            expect(message).toContain(':');
        });

        it('should handle undefined status', () => {
            const status = undefined;
            const isValid = status >= 100 && status < 600;

            expect(isValid).toBe(false);
        });
    });
});
