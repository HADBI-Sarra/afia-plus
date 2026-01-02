import { supabaseAdmin } from '../src/config/supabase.js';

export async function authMiddleware(req, res, next) {
  const token = req.headers.authorization?.replace('Bearer ', '');

  if (!token) {
    return res.status(401).json({ message: 'Missing token' });
  }

  const { data, error } = await supabaseAdmin.auth.getUser(token);

  if (error || !data.user) {
    return res.status(401).json({ message: 'Invalid token' });
  }

  req.user = data.user; // contains uuid
  next();
}
