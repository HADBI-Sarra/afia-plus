// controllers/auth.controller.js
import { supabaseAdmin, supabaseAuth } from '../src/config/supabase.js';

export async function signup(req, res) {
  const {
    email,
    password,
    firstname,
    lastname,
    phone_number,
    nin,
    date_of_birth,
  } = req.body;

  const { data: authUser, error } =
    await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
    });

  if (error) {
    return res.status(400).json({ message: error.message });
  }

  const { data: user, error: userError } = await supabaseAdmin
    .from('users')
    .insert({
      auth_uid: authUser.user.id,
      role: 'patient',
      firstname,
      lastname,
      email,
      phone_number,
      nin,
    })
    .select()
    .single();

  if (userError) {
    return res.status(400).json({ message: userError.message });
  }

  await supabaseAdmin.from('patients').insert({
    patient_id: user.user_id,
    date_of_birth,
  });

  const { data: signInData } =
    await supabaseAuth.auth.signInWithPassword({
      email,
      password,
    });

  res.status(200).json({
    user,
    access_token: signInData.session.access_token,
    refresh_token: signInData.session.refresh_token,
  });
}

export async function login(req, res) {
  const { email, password } = req.body;

  const { data, error } =
    await supabaseAuth.auth.signInWithPassword({
      email,
      password,
    });

  if (error || !data.session || !data.user) {
    return res.status(401).json({
      message: error?.message || 'Invalid credentials',
    });
  }

  const { data: userProfile, error: userError } = await supabaseAdmin
    .from('users')
    .select('*')
    .eq('auth_uid', data.user.id)
    .single();

  if (userError || !userProfile) {
    return res.status(404).json({
      message: 'User profile not found',
    });
  }

  res.json({
    access_token: data.session.access_token,
    refresh_token: data.session.refresh_token,
    user: userProfile,
  });
}

export async function me(req, res) {
  const { data, error } = await supabaseAdmin
    .from('users')
    .select('*')
    .eq('auth_uid', req.user.id)
    .single();

  if (error || !data) {
    return res.status(404).json({
      message: 'User profile not found',
    });
  }

  res.json(data);
}

export async function logout(req, res) {
  res.json({ message: 'Logged out' });
}
