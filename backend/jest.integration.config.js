/**
 * Jest configuration for integration tests
 * Extends base config with real Supabase connection
 */

export default {
    testEnvironment: 'node',
    transform: {},
    moduleFileExtensions: ['js', 'json'],

    // Only run integration tests
    testMatch: [
        '**/tests/integration/**/*.test.js'
    ],

    // Use integration test setup that loads real .env
    setupFilesAfterEnv: ['<rootDir>/tests/integration/setup.js'],

    // Ignore patterns
    testPathIgnorePatterns: [
        '/node_modules/',
        '/build/',
        '/tests/unit/'
    ],

    // Verbose output
    verbose: true,

    // Clear mocks between tests
    clearMocks: true,
    resetMocks: true,
    restoreMocks: true,

    // Longer timeout for integration tests
    testTimeout: 30000,

    // Run tests serially to avoid database conflicts
    maxWorkers: 1,

    // Collect coverage for integration tests
    collectCoverageFrom: [
        'controllers/**/*.js',
        'routes/**/*.js',
        'middlewares/**/*.js',
        '!**/*.test.js',
        '!**/node_modules/**'
    ]
};
