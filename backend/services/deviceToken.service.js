import { supabaseAdmin } from '../src/config/supabase.js';
import { logger } from '../utils/logger.js';

/**
 * Device Token Service
 * Manages FCM device tokens in Supabase database
 */
export class DeviceTokenService {
    /**
     * Store or update device token for a user
     * @param {number} userId - User ID
     * @param {string} token - FCM device token
     * @param {string} deviceType - Device type (optional, e.g., 'android', 'ios', 'web')
     * @returns {Promise<Object>} Stored token record
     */
    static async upsertToken(userId, token, deviceType = 'android') {
        try {
            if (!userId || !token) {
                throw new Error('User ID and token are required');
            }

            // Check if token already exists for this user
            const { data: existingToken } = await supabaseAdmin
                .from('device_tokens')
                .select('*')
                .eq('token', token)
                .single();

            if (existingToken) {
                // Update existing token if user_id changed or update timestamp
                if (existingToken.user_id !== userId) {
                    logger.info(`🔄 Updating token ownership from user ${existingToken.user_id} to ${userId}`);
                    const { data, error } = await supabaseAdmin
                        .from('device_tokens')
                        .update({
                            user_id: userId,
                            device_type: deviceType,
                            updated_at: new Date().toISOString()
                        })
                        .eq('token', token)
                        .select()
                        .single();

                    if (error) throw error;
                    logger.info('✅ Token ownership updated');
                    return data;
                } else {
                    // Token already exists for this user, just update timestamp
                    const { data, error } = await supabaseAdmin
                        .from('device_tokens')
                        .update({
                            device_type: deviceType,
                            updated_at: new Date().toISOString()
                        })
                        .eq('token', token)
                        .select()
                        .single();

                    if (error) throw error;
                    logger.info('✅ Token updated');
                    return data;
                }
            }

            // Check if user already has this token
            const { data: userToken } = await supabaseAdmin
                .from('device_tokens')
                .select('*')
                .eq('user_id', userId)
                .eq('token', token)
                .single();

            if (userToken) {
                // Update existing token
                const { data, error } = await supabaseAdmin
                    .from('device_tokens')
                    .update({
                        device_type: deviceType,
                        updated_at: new Date().toISOString()
                    })
                    .eq('id', userToken.id)
                    .select()
                    .single();

                if (error) throw error;
                logger.info('✅ Token updated for user');
                return data;
            }

            // Insert new token
            const { data, error } = await supabaseAdmin
                .from('device_tokens')
                .insert({
                    user_id: userId,
                    token: token,
                    device_type: deviceType,
                    created_at: new Date().toISOString(),
                    updated_at: new Date().toISOString()
                })
                .select()
                .single();

            if (error) throw error;
            logger.info(`✅ Token stored for user ${userId}`);
            return data;
        } catch (error) {
            logger.error('❌ Error storing device token:', error.message);
            throw error;
        }
    }

    /**
     * Get all device tokens for a user
     * @param {number} userId - User ID
     * @returns {Promise<Array>} Array of token records
     */
    static async getUserTokens(userId) {
        try {
            if (!userId) {
                throw new Error('User ID is required');
            }

            const { data, error } = await supabaseAdmin
                .from('device_tokens')
                .select('*')
                .eq('user_id', userId);

            if (error) throw error;
            return data || [];
        } catch (error) {
            logger.error(`❌ Error getting tokens for user ${userId}:`, error.message);
            return [];
        }
    }

    /**
     * Delete a device token
     * @param {string} token - FCM device token
     * @returns {Promise<boolean>} Success status
     */
    static async deleteToken(token) {
        try {
            if (!token) {
                throw new Error('Token is required');
            }

            const { error } = await supabaseAdmin
                .from('device_tokens')
                .delete()
                .eq('token', token);

            if (error) throw error;
            logger.info('✅ Token deleted');
            return true;
        } catch (error) {
            logger.error('❌ Error deleting token:', error.message);
            return false;
        }
    }

    /**
     * Delete all tokens for a user
     * @param {number} userId - User ID
     * @returns {Promise<boolean>} Success status
     */
    static async deleteUserTokens(userId) {
        try {
            if (!userId) {
                throw new Error('User ID is required');
            }

            const { error } = await supabaseAdmin
                .from('device_tokens')
                .delete()
                .eq('user_id', userId);

            if (error) throw error;
            logger.info(`✅ All tokens deleted for user ${userId}`);
            return true;
        } catch (error) {
            logger.error(`❌ Error deleting tokens for user ${userId}:`, error.message);
            return false;
        }
    }

    /**
     * Clean up old or invalid tokens (optional utility)
     * @param {number} daysOld - Delete tokens older than this many days
     * @returns {Promise<number>} Number of tokens deleted
     */
    static async cleanupOldTokens(daysOld = 90) {
        try {
            const cutoffDate = new Date();
            cutoffDate.setDate(cutoffDate.getDate() - daysOld);

            const { data, error } = await supabaseAdmin
                .from('device_tokens')
                .delete()
                .lt('updated_at', cutoffDate.toISOString())
                .select();

            if (error) throw error;
            const count = data?.length || 0;
            logger.info(`✅ Cleaned up ${count} old tokens`);
            return count;
        } catch (error) {
            logger.error('❌ Error cleaning up old tokens:', error.message);
            return 0;
        }
    }
}

