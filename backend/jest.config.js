export default {
    // Use Node's experimental ES modules support
    testEnvironment: 'node',

    // Transform ES modules
    transform: {},

    // File extensions to consider
    moduleFileExtensions: ['js', 'json'],

    // Test match patterns
    testMatch: [
        '**/tests/**/*.test.js',
        '**/__tests__/**/*.js'
    ],

    // Coverage configuration
    collectCoverageFrom: [
        'services/**/*.js',
        'controllers/**/*.js',
        'middlewares/**/*.js',
        'jobs/**/*.js',
        'utils/**/*.js',
        '!**/*.test.js',
        '!**/node_modules/**'
    ],

    // Coverage thresholds
    coverageThreshold: {
        global: {
            branches: 70,
            functions: 70,
            lines: 70,
            statements: 70
        }
    },

    // Setup files (optional - provides global test utilities)
    setupFilesAfterEnv: ['<rootDir>/tests/setup.js'],

    // Ignore patterns
    testPathIgnorePatterns: [
        '/node_modules/',
        '/build/'
    ],

    // Verbose output
    verbose: true,

    // Clear mocks between tests
    clearMocks: true,

    // Restore mocks between tests
    restoreMocks: true
};
