import { DeviceTokenService } from '../services/deviceToken.service.js';
import { sendResponse, sendError } from '../utils/response.js';
import { logger } from '../utils/logger.js';

/**
 * Device Token Controller
 * Handles HTTP requests for FCM token management
 */

/**
 * POST /device-tokens
 * Store or update device token for a user
 * Body: { userId, token, deviceType? }
 */
export async function upsertDeviceToken(req, res) {
    try {
        const { userId, token, deviceType } = req.body;

        if (!userId || !token) {
            return sendError(res, 400, 'User ID and token are required');
        }

        const result = await DeviceTokenService.upsertToken(
            userId,
            token,
            deviceType || 'android'
        );

        logger.info(`✅ Device token stored/updated for user ${userId}`);
        return sendResponse(res, 200, 'Device token stored successfully', result);
    } catch (error) {
        logger.error('❌ Error storing device token:', error.message);
        return sendError(res, 500, error.message);
    }
}

/**
 * GET /device-tokens/user/:userId
 * Get all device tokens for a user
 */
export async function getUserDeviceTokens(req, res) {
    try {
        const { userId } = req.params;

        if (!userId) {
            return sendError(res, 400, 'User ID is required');
        }

        const tokens = await DeviceTokenService.getUserTokens(userId);
        return sendResponse(res, 200, 'Device tokens retrieved successfully', tokens);
    } catch (error) {
        logger.error('❌ Error getting device tokens:', error.message);
        return sendError(res, 500, error.message);
    }
}

/**
 * DELETE /device-tokens/:token
 * Delete a device token
 */
export async function deleteDeviceToken(req, res) {
    try {
        const { token } = req.params;

        if (!token) {
            return sendError(res, 400, 'Token is required');
        }

        const success = await DeviceTokenService.deleteToken(token);
        
        if (success) {
            return sendResponse(res, 200, 'Device token deleted successfully', {});
        } else {
            return sendError(res, 500, 'Failed to delete device token');
        }
    } catch (error) {
        logger.error('❌ Error deleting device token:', error.message);
        return sendError(res, 500, error.message);
    }
}

/**
 * DELETE /device-tokens/user/:userId
 * Delete all device tokens for a user
 */
export async function deleteUserDeviceTokens(req, res) {
    try {
        const { userId } = req.params;

        if (!userId) {
            return sendError(res, 400, 'User ID is required');
        }

        const success = await DeviceTokenService.deleteUserTokens(userId);
        
        if (success) {
            return sendResponse(res, 200, 'All device tokens deleted successfully', {});
        } else {
            return sendError(res, 500, 'Failed to delete device tokens');
        }
    } catch (error) {
        logger.error('❌ Error deleting user device tokens:', error.message);
        return sendError(res, 500, error.message);
    }
}

