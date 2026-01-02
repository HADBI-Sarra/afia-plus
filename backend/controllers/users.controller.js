import { supabaseAdmin } from '../src/config/supabase.js';

export async function updateMe(req, res) {
  const { firstname, lastname, phone_number, profile_picture } = req.body;

  const { data } = await supabaseAdmin
    .from('users')
    .update({
      firstname,
      lastname,
      phone_number,
      profile_picture,
    })
    .eq('auth_uid', req.user.id)
    .select()
    .single();

  res.json(data);
}

export async function emailExists(req, res) {
  const { email } = req.query;

  const { data } = await supabaseAdmin
    .from('users')
    .select('user_id')
    .eq('email', email)
    .maybeSingle();

  res.json({ exists: !!data });
}
