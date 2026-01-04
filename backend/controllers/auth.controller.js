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

  // Fetch role-specific data to return complete user object
  let userData = { ...user };

  if (userRole === 'patient') {
    const { data: patient, error: patientError } = await supabaseAdmin
      .from('patients')
      .select('date_of_birth')
      .eq('patient_id', user.user_id)
      .maybeSingle();

    if (patientError) {
      console.error('Error fetching patient data:', patientError);
    }

    // Always include date_of_birth field, even if null or patient record doesn't exist
    userData.date_of_birth = patient?.date_of_birth ?? null;
  } else if (userRole === 'doctor') {
    const { data: doctor, error: doctorError } = await supabaseAdmin
      .from('doctors')
      .select('speciality_id, bio, location_of_work, degree, university, certification, institution, residency, license_number, license_description, years_experience, areas_of_expertise, price_per_hour, average_rating, reviews_count')
      .eq('doctor_id', user.user_id)
      .maybeSingle();

    if (doctorError) {
      console.error('Error fetching doctor data:', doctorError);
    }

    // Always include all doctor fields, even if null or doctor record doesn't exist
    userData = {
      ...userData,
      speciality_id: doctor?.speciality_id ?? null,
      bio: doctor?.bio ?? null,
      location_of_work: doctor?.location_of_work ?? null,
      degree: doctor?.degree ?? null,
      university: doctor?.university ?? null,
      certification: doctor?.certification ?? null,
      institution: doctor?.institution ?? null,
      residency: doctor?.residency ?? null,
      license_number: doctor?.license_number ?? null,
      license_description: doctor?.license_description ?? null,
      years_experience: doctor?.years_experience ?? null,
      areas_of_expertise: doctor?.areas_of_expertise ?? null,
      price_per_hour: doctor?.price_per_hour ?? null,
      average_rating: doctor?.average_rating ?? 0,
      reviews_count: doctor?.reviews_count ?? 0,
    };
  }

  res.status(200).json({
    user: userData,
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

  // Fetch role-specific data
  let userData = { ...userProfile };

  if (userProfile.role === 'patient') {
    console.log(`[LOGIN] Fetching patient data for user_id: ${userProfile.user_id}`);
    const { data: patient, error: patientError } = await supabaseAdmin
      .from('patients')
      .select('date_of_birth')
      .eq('patient_id', userProfile.user_id)
      .maybeSingle();

    if (patientError) {
      console.error('[LOGIN] Error fetching patient data:', patientError);
    }

    console.log(`[LOGIN] Patient data result:`, patient);
    console.log(`[LOGIN] Patient date_of_birth:`, patient?.date_of_birth);

    // Always include date_of_birth field, even if null or patient record doesn't exist
    userData.date_of_birth = patient?.date_of_birth ?? null;
    console.log(`[LOGIN] Final userData.date_of_birth:`, userData.date_of_birth);
  } else if (userProfile.role === 'doctor') {
    console.log(`[LOGIN] Fetching doctor data for user_id: ${userProfile.user_id}`);
    const { data: doctor, error: doctorError } = await supabaseAdmin
      .from('doctors')
      .select('speciality_id, bio, location_of_work, degree, university, certification, institution, residency, license_number, license_description, years_experience, areas_of_expertise, price_per_hour, average_rating, reviews_count')
      .eq('doctor_id', userProfile.user_id)
      .maybeSingle();

    if (doctorError) {
      console.error('[LOGIN] Error fetching doctor data:', doctorError);
    }

    console.log(`[LOGIN] Doctor data result:`, doctor);
    console.log(`[LOGIN] Doctor speciality_id:`, doctor?.speciality_id);

    // Always include all doctor fields, even if null or doctor record doesn't exist
    userData = {
      ...userData,
      speciality_id: doctor?.speciality_id ?? null,
      bio: doctor?.bio ?? null,
      location_of_work: doctor?.location_of_work ?? null,
      degree: doctor?.degree ?? null,
      university: doctor?.university ?? null,
      certification: doctor?.certification ?? null,
      institution: doctor?.institution ?? null,
      residency: doctor?.residency ?? null,
      license_number: doctor?.license_number ?? null,
      license_description: doctor?.license_description ?? null,
      years_experience: doctor?.years_experience ?? null,
      areas_of_expertise: doctor?.areas_of_expertise ?? null,
      price_per_hour: doctor?.price_per_hour ?? null,
      average_rating: doctor?.average_rating ?? 0,
      reviews_count: doctor?.reviews_count ?? 0,
    };
  }

  console.log(`[LOGIN] Final response userData keys:`, Object.keys(userData));
  console.log(`[LOGIN] Final response userData.date_of_birth:`, userData.date_of_birth);
  console.log(`[LOGIN] Final response userData.speciality_id:`, userData.speciality_id);
  
  res.json({
    access_token: data.session.access_token,
    refresh_token: data.session.refresh_token,
    user: userData,
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

  // Fetch role-specific data
  let userData = { ...data };

  if (data.role === 'patient') {
    console.log(`[ME] Fetching patient data for user_id: ${data.user_id}`);
    const { data: patient, error: patientError } = await supabaseAdmin
      .from('patients')
      .select('date_of_birth')
      .eq('patient_id', data.user_id)
      .maybeSingle();

    if (patientError) {
      console.error('[ME] Error fetching patient data:', patientError);
    }

    console.log(`[ME] Patient data result:`, patient);
    console.log(`[ME] Patient date_of_birth:`, patient?.date_of_birth);

    // Always include date_of_birth field, even if null or patient record doesn't exist
    userData.date_of_birth = patient?.date_of_birth ?? null;
    console.log(`[ME] Final userData.date_of_birth:`, userData.date_of_birth);
  } else if (data.role === 'doctor') {
    console.log(`[ME] Fetching doctor data for user_id: ${data.user_id}`);
    const { data: doctor, error: doctorError } = await supabaseAdmin
      .from('doctors')
      .select('speciality_id, bio, location_of_work, degree, university, certification, institution, residency, license_number, license_description, years_experience, areas_of_expertise, price_per_hour, average_rating, reviews_count')
      .eq('doctor_id', data.user_id)
      .maybeSingle();

    if (doctorError) {
      console.error('[ME] Error fetching doctor data:', doctorError);
    }

    console.log(`[ME] Doctor data result:`, doctor);
    console.log(`[ME] Doctor speciality_id:`, doctor?.speciality_id);

    // Always include all doctor fields, even if null or doctor record doesn't exist
    userData = {
      ...userData,
      speciality_id: doctor?.speciality_id ?? null,
      bio: doctor?.bio ?? null,
      location_of_work: doctor?.location_of_work ?? null,
      degree: doctor?.degree ?? null,
      university: doctor?.university ?? null,
      certification: doctor?.certification ?? null,
      institution: doctor?.institution ?? null,
      residency: doctor?.residency ?? null,
      license_number: doctor?.license_number ?? null,
      license_description: doctor?.license_description ?? null,
      years_experience: doctor?.years_experience ?? null,
      areas_of_expertise: doctor?.areas_of_expertise ?? null,
      price_per_hour: doctor?.price_per_hour ?? null,
      average_rating: doctor?.average_rating ?? 0,
      reviews_count: doctor?.reviews_count ?? 0,
    };
  }

  console.log(`[ME] Final response userData keys:`, Object.keys(userData));
  console.log(`[ME] Final response userData.date_of_birth:`, userData.date_of_birth);
  console.log(`[ME] Final response userData.speciality_id:`, userData.speciality_id);
  
  res.json(userData);
}

export async function logout(req, res) {
  res.json({ message: 'Logged out' });
}
