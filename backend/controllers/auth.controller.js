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
    role,
    // Doctor-specific fields
    speciality_id,
    bio,
    location_of_work,
    degree,
    university,
    certification,
    institution,
    residency,
    license_number,
    license_description,
    years_experience,
    areas_of_expertise,
    price_per_hour,
  } = req.body;

  // Validate role - must be 'patient' or 'doctor'
  const userRole = role?.toLowerCase().trim();
  
  if (!userRole || (userRole !== 'patient' && userRole !== 'doctor')) {
    return res.status(400).json({ 
      message: 'Invalid role. Must be "patient" or "doctor"' 
    });
  }

  // Explicit validation: date_of_birth should NOT be present for doctors
  if (userRole === 'doctor' && date_of_birth) {
    return res.status(400).json({ 
      message: 'Date of birth should not be provided for doctor signup' 
    });
  }

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
      role: userRole,
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

  // Handle patient signup
  if (userRole === 'patient') {
    if (!date_of_birth) {
      return res.status(400).json({ message: 'Date of birth is required for patients' });
    }
    
    const { error: patientError } = await supabaseAdmin.from('patients').insert({
      patient_id: user.user_id,
      date_of_birth,
    });

    if (patientError) {
      return res.status(400).json({ message: patientError.message });
    }
  }
  // Handle doctor signup - explicitly prevent patient creation
  else if (userRole === 'doctor') {
    // First, check if a patient record was accidentally created (e.g., by a database trigger)
    // and delete it if it exists
    const { data: existingPatient } = await supabaseAdmin
      .from('patients')
      .select('patient_id')
      .eq('patient_id', user.user_id)
      .maybeSingle();

    if (existingPatient) {
      // Delete any accidentally created patient record
      await supabaseAdmin
        .from('patients')
        .delete()
        .eq('patient_id', user.user_id);
    }

    const { error: doctorError } = await supabaseAdmin.from('doctors').insert({
      doctor_id: user.user_id,
      speciality_id: speciality_id || null,
      bio: bio || null,
      location_of_work: location_of_work || null,
      degree: degree || null,
      university: university || null,
      certification: certification || null,
      institution: institution || null,
      residency: residency || null,
      license_number: license_number || null,
      license_description: license_description || null,
      years_experience: years_experience || null,
      areas_of_expertise: areas_of_expertise || null,
      price_per_hour: price_per_hour || null,
      average_rating: 0,
      reviews_count: 0,
    });

    if (doctorError) {
      // If doctor creation fails, we should clean up the user record
      await supabaseAdmin.from('users').delete().eq('user_id', user.user_id);
      return res.status(400).json({ message: doctorError.message });
    }

    // Final safeguard: verify no patient record exists after doctor creation
    const { data: patientCheck } = await supabaseAdmin
      .from('patients')
      .select('patient_id')
      .eq('patient_id', user.user_id)
      .maybeSingle();

    if (patientCheck) {
      // If a patient record was created (e.g., by a trigger), delete it
      await supabaseAdmin
        .from('patients')
        .delete()
        .eq('patient_id', user.user_id);
    }
  } else {
    // This should never happen due to validation above, but just in case
    return res.status(400).json({ message: 'Invalid role specified' });
  }

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
