/**
 * Logger utility - only logs in development mode
 * In production, these become no-ops
 */

const isDevelopment = process.env.NODE_ENV === 'development';

export const logger = {
    log: (...args) => {
        if (isDevelopment) {
            console.log(...args);
        }
    },

    error: (...args) => {
        // Always log errors, even in production
        console.error(...args);
    },

    warn: (...args) => {
        if (isDevelopment) {
            console.warn(...args);
        }
    },

    info: (...args) => {
        if (isDevelopment) {
            console.info(...args);
        }
    }
};
