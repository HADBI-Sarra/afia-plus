/**
 * Send successful response
 */
export const sendResponse = (res, status, message, data = null) => {
    res.status(status).json({
        status,
        message,
        ...(data && { data }),
    });
};

/**
 * Send error response
 */
export const sendError = (res, status, message, error = null) => {
    console.error(`[Error ${status}] ${message}:`, error);
    res.status(status).json({
        status,
        message,
        ...(error && process.env.NODE_ENV === 'development' && { error: error.message }),
    });
};
