import { supabase } from '../src/config/supabase.js';

export async function updateMe(req, res) {
  const { firstname, lastname, phone_number, profile_picture } = req.body;

  const { data } = await supabase
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
  try {
    const { email } = req.query;
    
    if (!email) {
      return res.status(400).json({ error: 'Email is required' });
    }

    const { data, error } = await supabase
      .from('users')
      .select('user_id')
      .eq('email', email)
      .maybeSingle();

    if (error) {
      console.error('Error checking if email exists:', error);
      return res.status(500).json({ error: 'Failed to check email' });
    }

    res.json({ exists: !!data });
  } catch (error) {
    console.error('emailExists exception:', error);
    res.status(500).json({ error: 'Server error' });
  }
}
