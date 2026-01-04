import { supabaseAdmin } from '../src/config/supabase.js';

export async function getMe(req, res) {
  const { data: user } = await supabaseAdmin
    .from('users')
    .select('*')
    .eq('auth_uid', req.user.id)
    .maybeSingle();

  if (!user) {
    return res.status(404).json({ message: 'User not found' });
  }

  const { data: patient } = await supabaseAdmin
    .from('patients')
    .select('date_of_birth')
    .eq('patient_id', user.user_id)
    .maybeSingle();

  res.json({
    ...user,
    date_of_birth: patient?.date_of_birth ?? null,
  });
}
