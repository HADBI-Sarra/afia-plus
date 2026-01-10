-- Create device_tokens table for storing FCM device tokens
-- This table stores Firebase Cloud Messaging tokens for each user's devices

CREATE TABLE IF NOT EXISTS device_tokens (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    token TEXT NOT NULL UNIQUE,
    device_type VARCHAR(20) DEFAULT 'android',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index for faster lookups by user_id
CREATE INDEX IF NOT EXISTS idx_device_tokens_user_id ON device_tokens(user_id);

-- Create index for token lookups
CREATE INDEX IF NOT EXISTS idx_device_tokens_token ON device_tokens(token);

-- Create index for cleaning up old tokens
CREATE INDEX IF NOT EXISTS idx_device_tokens_updated_at ON device_tokens(updated_at);

-- Add comment to table
COMMENT ON TABLE device_tokens IS 'Stores FCM device tokens for push notifications';
COMMENT ON COLUMN device_tokens.user_id IS 'Foreign key to users table';
COMMENT ON COLUMN device_tokens.token IS 'FCM device token (unique per device)';
COMMENT ON COLUMN device_tokens.device_type IS 'Device type: android, ios, or web';
COMMENT ON COLUMN device_tokens.created_at IS 'When the token was first registered';
COMMENT ON COLUMN device_tokens.updated_at IS 'Last time the token was updated';

