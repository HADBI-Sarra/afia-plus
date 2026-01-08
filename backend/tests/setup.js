// Test setup file
// This runs before all tests

// Mock environment variables
process.env.SUPABASE_URL = 'https://test.supabase.co';
process.env.SUPABASE_SERVICE_KEY = 'test-service-key';
process.env.JWT_SECRET = 'test-jwt-secret';
process.env.PORT = '3001';

// Global test utilities
global.testUtils = {
    // Helper to generate random test data
    generateRandomEmail: () => `test-${Date.now()}@example.com`,
    generateRandomPhone: () => `555${Math.floor(1000000 + Math.random() * 9000000)}`,

    // Helper to create mock dates
    getFutureDate: (daysFromNow = 1) => {
        const date = new Date();
        date.setDate(date.getDate() + daysFromNow);
        return date.toISOString().split('T')[0];
    },

    getPastDate: (daysAgo = 1) => {
        const date = new Date();
        date.setDate(date.getDate() - daysAgo);
        return date.toISOString().split('T')[0];
    }
};
