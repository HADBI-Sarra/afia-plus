import express from 'express';
import {
    upsertDeviceToken,
    getUserDeviceTokens,
    deleteDeviceToken,
    deleteUserDeviceTokens
} from '../controllers/deviceToken.controller.js';

const router = express.Router();

/**
 * Device Token Routes
 * POST   /device-tokens              - Store/update device token
 * GET    /device-tokens/user/:userId - Get user's device tokens
 * DELETE /device-tokens/:token       - Delete specific token
 * DELETE /device-tokens/user/:userId - Delete all user's tokens
 */

router.post('/', upsertDeviceToken);
router.get('/user/:userId', getUserDeviceTokens);
router.delete('/:token', deleteDeviceToken);
router.delete('/user/:userId', deleteUserDeviceTokens);

export default router;

