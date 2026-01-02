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

  // 1️⃣ Create auth user
  const { data: authUser, error } =
    await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
    });

  if (error) {
    return res.status(400).json({ message: error.message });
  }

  // 2️⃣ Insert users row
  const { data: user, error: userError } = await supabaseAdmin
    .from('users')
    .insert({
      auth_uid: authUser.user.id, // UUID
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

  // 3️⃣ Insert patient
  await supabaseAdmin.from('patients').insert({
    patient_id: user.user_id,
    date_of_birth,
  });

  // 4️⃣ Login
  const { data: signInData } =
    await supabaseAuth.auth.signInWithPassword({
      email,
      password,
    });

  res.json({
    access_token: signInData.session.access_token,
    refresh_token: signInData.session.refresh_token,
    user,
  });
}

export async function login(req, res) {
  const { email, password } = req.body;

  // 🔐 Authenticate
  const { data, error } =
    await supabaseAuth.auth.signInWithPassword({
      email,
      password,
    });

  if (error || !data.session) {
    return res.status(401).json({ message: 'Invalid credentials' });
  }

  // ✅ SAFE fetch profile
  const { data: userProfile } = await supabaseAdmin
    .from('users')
    .select('*')
    .eq('auth_uid', data.user.id)
    .maybeSingle();

  // 🚨 ALWAYS return user key
  res.json({
    access_token: data.session.access_token,
    refresh_token: data.session.refresh_token,
    user: userProfile ?? null,
  });
}

export async function me(req, res) {
  const { data } = await supabaseAdmin
    .from('users')
    .select('*')
    .eq('auth_uid', req.user.id)
    .maybeSingle();

  res.json(data);
}
