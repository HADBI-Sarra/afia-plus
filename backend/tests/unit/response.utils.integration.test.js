import { describe, it, expect, jest, beforeEach } from '@jest/globals';
import { sendResponse, sendError } from '../../utils/response.js';

/**
 * Integration Tests for Response Utilities
 * Tests actual response formatting functions
 */
describe('Response Utils - Integration Tests', () => {
    let mockRes;
    let consoleErrorSpy;

    beforeEach(() => {
        jest.clearAllMocks();

        // Setup mock response object
        mockRes = {
            status: jest.fn().mockReturnThis(),
            json: jest.fn().mockReturnThis()
        };

        // Spy on console.error
        consoleErrorSpy = jest.spyOn(console, 'error').mockImplementation(() => { });
    });

    afterEach(() => {
        consoleErrorSpy.mockRestore();
    });

    describe('sendResponse - Success Responses', () => {
        it('should send response with status 200 and data', () => {
            const testData = { id: 1, name: 'Test User' };

            sendResponse(mockRes, 200, 'Success', testData);

            expect(mockRes.status).toHaveBeenCalledWith(200);
            expect(mockRes.json).toHaveBeenCalledWith({
                status: 200,
                message: 'Success',
                data: testData
            });
        });

        it('should send response without data when null', () => {
            sendResponse(mockRes, 200, 'Success', null);

            expect(mockRes.status).toHaveBeenCalledWith(200);
            expect(mockRes.json).toHaveBeenCalledWith({
                status: 200,
                message: 'Success'
            });
        });

        it('should send response without data when undefined', () => {
            sendResponse(mockRes, 200, 'Success');

            const jsonCall = mockRes.json.mock.calls[0][0];
            expect(jsonCall).toEqual({
                status: 200,
                message: 'Success'
            });
            expect(jsonCall).not.toHaveProperty('data');
        });

        it('should handle array data', () => {
            const arrayData = [{ id: 1 }, { id: 2 }, { id: 3 }];

            sendResponse(mockRes, 200, 'List retrieved', arrayData);

            expect(mockRes.json).toHaveBeenCalledWith({
                status: 200,
                message: 'List retrieved',
                data: arrayData
            });
        });

        it('should handle empty array data', () => {
            sendResponse(mockRes, 200, 'No results', []);

            expect(mockRes.json).toHaveBeenCalledWith({
                status: 200,
                message: 'No results',
                data: []
            });
        });

        it('should handle 201 Created status', () => {
            const newResource = { id: 100, name: 'New Item' };

            sendResponse(mockRes, 201, 'Created successfully', newResource);

            expect(mockRes.status).toHaveBeenCalledWith(201);
            expect(mockRes.json).toHaveBeenCalledWith({
                status: 201,
                message: 'Created successfully',
                data: newResource
            });
        });

        it('should handle 204 No Content status', () => {
            sendResponse(mockRes, 204, 'Deleted successfully');

            expect(mockRes.status).toHaveBeenCalledWith(204);
            expect(mockRes.json).toHaveBeenCalledWith({
                status: 204,
                message: 'Deleted successfully'
            });
        });

        it('should handle complex nested data', () => {
            const complexData = {
                user: {
                    id: 1,
                    profile: {
                        name: 'John',
                        settings: { theme: 'dark' }
                    }
                },
                consultations: [{ id: 1 }, { id: 2 }]
            };

            sendResponse(mockRes, 200, 'Success', complexData);

            expect(mockRes.json).toHaveBeenCalledWith({
                status: 200,
                message: 'Success',
                data: complexData
            });
        });
    });

    describe('sendError - Error Responses', () => {
        it('should send error with status 400', () => {
            sendError(mockRes, 400, 'Bad request');

            expect(mockRes.status).toHaveBeenCalledWith(400);
            expect(mockRes.json).toHaveBeenCalledWith({
                status: 400,
                message: 'Bad request'
            });
            expect(consoleErrorSpy).toHaveBeenCalled();
        });

        it('should send error with status 404', () => {
            sendError(mockRes, 404, 'Resource not found');

            expect(mockRes.status).toHaveBeenCalledWith(404);
            expect(mockRes.json).toHaveBeenCalledWith({
                status: 404,
                message: 'Resource not found'
            });
        });

        it('should send error with status 500', () => {
            sendError(mockRes, 500, 'Internal server error');

            expect(mockRes.status).toHaveBeenCalledWith(500);
            expect(mockRes.json).toHaveBeenCalledWith({
                status: 500,
                message: 'Internal server error'
            });
        });

        it('should log error to console', () => {
            const error = new Error('Database connection failed');

            sendError(mockRes, 500, 'Server error', error);

            expect(consoleErrorSpy).toHaveBeenCalledWith(
                '[Error 500] Server error:',
                error
            );
        });

        it('should include error details in development mode', () => {
            const originalEnv = process.env.NODE_ENV;
            process.env.NODE_ENV = 'development';

            const error = new Error('Detailed error message');
            sendError(mockRes, 500, 'Server error', error);

            expect(mockRes.json).toHaveBeenCalledWith({
                status: 500,
                message: 'Server error',
                error: 'Detailed error message'
            });

            process.env.NODE_ENV = originalEnv;
        });

        it('should NOT include error details in production mode', () => {
            const originalEnv = process.env.NODE_ENV;
            process.env.NODE_ENV = 'production';

            const error = new Error('Sensitive error details');
            sendError(mockRes, 500, 'Server error', error);

            const jsonCall = mockRes.json.mock.calls[0][0];
            expect(jsonCall).not.toHaveProperty('error');
            expect(JSON.stringify(jsonCall)).not.toContain('Sensitive');

            process.env.NODE_ENV = originalEnv;
        });

        it('should handle error without error object', () => {
            sendError(mockRes, 400, 'Validation failed');

            const jsonCall = mockRes.json.mock.calls[0][0];
            expect(jsonCall).not.toHaveProperty('error');
        });

        it('should handle null error object', () => {
            sendError(mockRes, 400, 'Invalid input', null);

            const jsonCall = mockRes.json.mock.calls[0][0];
            expect(jsonCall).toEqual({
                status: 400,
                message: 'Invalid input'
            });
        });
    });

    describe('HTTP Status Code Handling', () => {
        it('should handle 2xx success codes', () => {
            sendResponse(mockRes, 200, 'OK');
            sendResponse(mockRes, 201, 'Created');
            sendResponse(mockRes, 204, 'No Content');

            expect(mockRes.status).toHaveBeenCalledWith(200);
            expect(mockRes.status).toHaveBeenCalledWith(201);
            expect(mockRes.status).toHaveBeenCalledWith(204);
        });

        it('should handle 4xx client error codes', () => {
            sendError(mockRes, 400, 'Bad Request');
            sendError(mockRes, 401, 'Unauthorized');
            sendError(mockRes, 403, 'Forbidden');
            sendError(mockRes, 404, 'Not Found');

            expect(mockRes.status).toHaveBeenCalledWith(400);
            expect(mockRes.status).toHaveBeenCalledWith(401);
            expect(mockRes.status).toHaveBeenCalledWith(403);
            expect(mockRes.status).toHaveBeenCalledWith(404);
        });

        it('should handle 5xx server error codes', () => {
            sendError(mockRes, 500, 'Internal Server Error');
            sendError(mockRes, 502, 'Bad Gateway');
            sendError(mockRes, 503, 'Service Unavailable');

            expect(mockRes.status).toHaveBeenCalledWith(500);
            expect(mockRes.status).toHaveBeenCalledWith(502);
            expect(mockRes.status).toHaveBeenCalledWith(503);
        });
    });

    describe('Edge Cases', () => {
        it('should handle empty message string', () => {
            sendResponse(mockRes, 200, '');

            expect(mockRes.json).toHaveBeenCalledWith({
                status: 200,
                message: ''
            });
        });

        it('should handle very long messages', () => {
            const longMessage = 'Error '.repeat(100);

            sendError(mockRes, 500, longMessage);

            const jsonCall = mockRes.json.mock.calls[0][0];
            expect(jsonCall.message).toBe(longMessage);
        });

        it('should handle special characters in message', () => {
            const specialMessage = 'User "John\'s" data <script>alert("xss")</script>';

            sendResponse(mockRes, 200, specialMessage);

            const jsonCall = mockRes.json.mock.calls[0][0];
            expect(jsonCall.message).toBe(specialMessage);
        });

        it('should handle unicode characters', () => {
            sendResponse(mockRes, 200, 'Успех 成功 نجاح', { value: '✓' });

            expect(mockRes.json).toHaveBeenCalled();
        });

        it('should handle boolean data', () => {
            sendResponse(mockRes, 200, 'Result', true);

            expect(mockRes.json).toHaveBeenCalledWith({
                status: 200,
                message: 'Result',
                data: true
            });
        });

        it('should handle numeric zero as data (falsy value filtered)', () => {
            sendResponse(mockRes, 200, 'Count', 0);

            // Note: 0 is falsy, so data field is not included due to ...(data && { data })
            expect(mockRes.json).toHaveBeenCalledWith({
                status: 200,
                message: 'Count'
            });
        });

        it('should handle empty string as data (falsy value filtered)', () => {
            sendResponse(mockRes, 200, 'Empty result', '');

            // Note: '' is falsy, so data field is not included
            expect(mockRes.json).toHaveBeenCalledWith({
                status: 200,
                message: 'Empty result'
            });
        });
    });

    describe('Chaining Behavior', () => {
        it('should allow method chaining', () => {
            const result = sendResponse(mockRes, 200, 'Success', { test: true });

            // Should return the res object (via mockReturnThis)
            expect(mockRes.status).toHaveBeenCalled();
            expect(mockRes.json).toHaveBeenCalled();
        });

        it('should allow error chaining', () => {
            sendError(mockRes, 400, 'Error');

            expect(mockRes.status).toHaveBeenCalled();
            expect(mockRes.json).toHaveBeenCalled();
        });
    });
});
