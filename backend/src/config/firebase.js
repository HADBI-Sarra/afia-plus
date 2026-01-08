import admin from 'firebase-admin';
import { logger } from '../../utils/logger.js';
import path from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

/**
 * Initialize Firebase Admin SDK
 * Expects FIREBASE_SERVICE_ACCOUNT environment variable to be a JSON string or path to JSON file
 */
let firebaseAdmin = null;

try {
    const serviceAccountPath = process.env.FIREBASE_SERVICE_ACCOUNT;
    
    if (!serviceAccountPath) {
        throw new Error('FIREBASE_SERVICE_ACCOUNT environment variable is not set');
    }

    let serviceAccount;
    
    // Check if it's a JSON string or a file path
    if (serviceAccountPath.startsWith('{')) {
        // It's a JSON string
        serviceAccount = JSON.parse(serviceAccountPath);
    } else {
        // It's a file path
        const fullPath = path.resolve(__dirname, '../../', serviceAccountPath);
        if (!fs.existsSync(fullPath)) {
            throw new Error(`Firebase service account file not found at: ${fullPath}`);
        }
        const serviceAccountFile = fs.readFileSync(fullPath, 'utf8');
        serviceAccount = JSON.parse(serviceAccountFile);
    }

    // Initialize Firebase Admin if not already initialized
    if (admin.apps.length === 0) {
        firebaseAdmin = admin.initializeApp({
            credential: admin.credential.cert(serviceAccount)
        });
        logger.info('✅ Firebase Admin SDK initialized successfully');
    } else {
        firebaseAdmin = admin.app();
        logger.info('✅ Firebase Admin SDK already initialized');
    }
} catch (error) {
    logger.error('❌ Failed to initialize Firebase Admin SDK:', error.message);
    // Don't throw - allow server to start even if Firebase is misconfigured
    // Notifications will fail gracefully
}

export { firebaseAdmin };

