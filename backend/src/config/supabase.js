import { createClient } from '@supabase/supabase-js';

if (!process.env.SUPABASE_URL) {
  throw new Error('ENV NOT LOADED — SUPABASE_URL missing');
}

// Validate service role key presence and value early to provide a clear error
if (!process.env.SUPABASE_SERVICE_ROLE_KEY) {
  throw new Error(
    'ENV NOT LOADED — SUPABASE_SERVICE_ROLE_KEY missing. Set it to your Supabase Service Role Key (Project > Settings > API)'
  );
}

// Common mistake: using the publishable key instead of the service role key
if (String(process.env.SUPABASE_SERVICE_ROLE_KEY).startsWith('sb_publishable')) {
  throw new Error(
    'Invalid SUPABASE_SERVICE_ROLE_KEY: a publishable key was provided. Replace it with the Service Role Key from Supabase Project Settings > API.'
  );
}

export const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_SERVICE_ROLE_KEY
);
