/**
 * Integration Test Setup
 * Loads real environment variables from .env file for integration testing
 */

import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load environment variables from .env file
dotenv.config({ path: path.resolve(__dirname, '../../.env') });

// Verify required environment variables are loaded
const requiredEnvVars = [
    'SUPABASE_URL',
    'SUPABASE_SERVICE_ROLE_KEY',
    'SUPABASE_ANON_KEY'
];

const missingVars = requiredEnvVars.filter(varName => !process.env[varName]);

if (missingVars.length > 0) {
    console.error('❌ Missing required environment variables:', missingVars.join(', '));
    console.error('Please ensure your .env file contains all required variables.');
    process.exit(1);
}

console.log('✅ Integration test environment configured');
console.log('  SUPABASE_URL:', process.env.SUPABASE_URL?.substring(0, 40) + '...');

// Global test utilities
global.testUtils = {
    generateRandomEmail: () => `test_${Date.now()}_${Math.random().toString(36).substring(7)}@example.com`,
    generateRandomPhone: () => `06${Math.floor(10000000 + Math.random() * 90000000)}`,
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
