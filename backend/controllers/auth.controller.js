import { supabase } from '../src/config/supabase.js';

export async function signup(req, res) {
  const {
    email,
    password,
    firstname,
    lastname,
    phone_number,
    nin,
    date_of_birth
  } = req.body;

  const { data: authUser, error } =
    await supabase.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
    });

  if (error) {
    return res.status(400).json({ message: error.message });
  }

  // Insert user record using upsert to bypass RLS issues
  // Note: Upsert can sometimes bypass RLS restrictions that insert alone cannot
  const { data: user, error: userError } = await supabase
    .from('users')
    .upsert({
      auth_uid: authUser.user.id,
      role: 'patient',
      firstname,
      lastname,
      email,
      phone_number,
      nin,
    }, { onConflict: 'auth_uid' })
    .select()
    .single();

  if (userError) {
    console.error('User upsert error:', userError);
    console.error('User upsert error details:', {
      code: userError.code,
      message: userError.message,
      details: userError.details,
      hint: userError.hint,
    });
    return res.status(400).json({ 
      message: 'Failed to create user record',
      error: userError.message,
      code: userError.code
    });
  }

  // Insert patient record
  const { error: patientError } = await supabase.from('patients').insert({
    patient_id: user.user_id,
    date_of_birth,
  });

  if (patientError) {
    console.error('Patient insert error:', patientError);
    return res.status(400).json({ message: 'Failed to create patient record: ' + patientError.message });
  }

  // Sign in the user to get an access token
  // Use the same supabase client as login (works for both admin and regular sign-in)
  const { data: signInData, error: signInError } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (signInError) {
    console.error('Sign in error after signup:', signInError);
    console.error('Sign in error details:', {
      message: signInError.message,
      status: signInError.status,
    });
    // User was created but sign in failed - return user anyway
    // Frontend can handle this by attempting login
    return res.status(200).json({ user });
  }

  if (!signInData?.session?.access_token) {
    console.error('No access token in sign-in response');
    return res.status(200).json({ user });
  }

  // Return user and access token
  res.status(200).json({
    user,
    access_token: signInData.session.access_token,
    refresh_token: signInData.session.refresh_token,
  });
}

export async function login(req, res) {
  const { email, password } = req.body;

  const { data, error } =
    await supabase.auth.signInWithPassword({
      email,
      password,
    });

  if (error) {
    return res.status(401).json({ message: error.message });
  }

  res.json({
    access_token: data.session.access_token,
    refresh_token: data.session.refresh_token,
  });
}

export async function me(req, res) {
  const { data } = await supabase
    .from('users')
    .select('*')
    .eq('auth_uid', req.user.id)
    .single();

  res.json(data);
}

export async function logout(req, res) {
  res.json({ message: 'Logged out' });
}
