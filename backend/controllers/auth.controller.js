// controllers/auth.controller.js
import { supabaseAdmin, supabaseAuth } from '../src/config/supabase.js';

// Validation functions
function validateEmail(email) {
  if (!email || email.trim() === '') {
    return 'Email cannot be empty';
  }
  const emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
  if (!emailRegex.test(email.trim())) {
    return 'Enter a valid email';
  }
  return null;
}

function validatePassword(password) {
  if (!password || password.trim() === '') {
    return 'Password cannot be empty';
  }
  const trimmedPassword = password.trim();
  const hasLowercase = /[a-z]/.test(trimmedPassword);
  const hasUppercase = /[A-Z]/.test(trimmedPassword);
  const hasNumber = /[0-9]/.test(trimmedPassword);
  const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(trimmedPassword);
  const isLongEnough = trimmedPassword.length >= 8;

  if (!isLongEnough || !hasLowercase || !hasUppercase || !hasNumber || !hasSpecialChar) {
    return 'Weak password';
  }
  return null;
}

function validateName(name, fieldName) {
  if (!name || name.trim() === '') {
    return `${fieldName} cannot be empty`;
  }
  const nameRegex = /^[A-Za-z'-]{2,}$/;
  if (!nameRegex.test(name.trim())) {
    return `Enter a valid ${fieldName}`;
  }
  return null;
}

function validatePhone(phone) {
  if (!phone || phone.trim() === '') {
    return 'Phone number cannot be empty';
  }
  const phoneRegex = /^0[567][0-9]{8}$/;
  if (!phoneRegex.test(phone.trim())) {
    return 'Enter a valid phone number';
  }
  return null;
}

function validateNin(nin) {
  if (!nin || nin.trim() === '') {
    return 'NIN cannot be empty';
  }
  const ninRegex = /^[0-9]{18}$/;
  if (!ninRegex.test(nin.trim())) {
    return 'Enter a valid NIN';
  }
  return null;
}

// Helper function to get days in a month
function getDaysInMonth(year, month) {
  return new Date(year, month, 0).getDate();
}

// Helper function to validate date components
function isValidDate(year, month, day) {
  if (month < 1 || month > 12) return false;
  if (day < 1) return false;
  const daysInMonth = getDaysInMonth(year, month);
  if (day > daysInMonth) return false;
  return true;
}

function validateDob(dob) {
  if (!dob || dob.trim() === '') {
    return 'Date of birth cannot be empty';
  }

  try {
    let year, month, day;

    if (dob.includes('/')) {
      // Handle DD/MM/YYYY format (explicitly parse as day/month/year)
      const parts = dob.split('/');
      if (parts.length !== 3) {
        return 'Invalid date format';
      }
      // IMPORTANT: parts[0] = day, parts[1] = month, parts[2] = year (DD/MM/YYYY format)
      day = parseInt(parts[0], 10);
      month = parseInt(parts[1], 10);
      year = parseInt(parts[2], 10);

      // Validate the components are valid numbers
      if (isNaN(day) || isNaN(month) || isNaN(year)) {
        return 'Invalid date format';
      }

      // Validate ranges and date validity
      if (!isValidDate(year, month, day)) {
        return 'Invalid date format';
      }

      // Additional year range validation
      if (year < 1900 || year > new Date().getFullYear()) {
        return 'Invalid date format';
      }
    } else if (dob.includes('-')) {
      // Handle YYYY-MM-DD format
      const parts = dob.split('-');
      if (parts.length !== 3) {
        return 'Invalid date format';
      }
      year = parseInt(parts[0], 10);
      month = parseInt(parts[1], 10);
      day = parseInt(parts[2], 10);

      if (isNaN(year) || isNaN(month) || isNaN(day)) {
        return 'Invalid date format';
      }

      if (!isValidDate(year, month, day)) {
        return 'Invalid date format';
      }

      if (year < 1900 || year > new Date().getFullYear()) {
        return 'Invalid date format';
      }
    } else {
      return 'Invalid date format';
    }

    // Calculate age accurately
    const today = new Date();
    const birthDate = new Date(year, month - 1, day);
    let age = today.getFullYear() - year;
    const monthDiff = today.getMonth() - (month - 1);
    const dayDiff = today.getDate() - day;

    // Adjust age if birthday hasn't occurred this year yet
    if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
      age--;
    }

    if (age < 16) {
      return 'You must be at least 16 years old';
    }
  } catch (error) {
    return 'Invalid date format';
  }
  return null;
}

function convertDobToISO(dob) {
  if (!dob || dob.trim() === '') {
    return null;
  }

  try {
    let day, month, year;

    if (dob.includes('/')) {
      // Handle DD/MM/YYYY format (explicitly parse as day/month/year)
      const parts = dob.split('/');
      if (parts.length !== 3) {
        return null;
      }
      // IMPORTANT: parts[0] = day, parts[1] = month, parts[2] = year (DD/MM/YYYY format)
      day = parseInt(parts[0], 10);
      month = parseInt(parts[1], 10);
      year = parseInt(parts[2], 10);

      // Validate the components are valid numbers
      if (isNaN(day) || isNaN(month) || isNaN(year)) {
        return null;
      }

      // Validate date validity (including checking days per month)
      if (!isValidDate(year, month, day)) {
        return null;
      }

      // Additional year range validation
      if (year < 1900 || year > new Date().getFullYear()) {
        return null;
      }

      // Convert directly to YYYY-MM-DD format without Date object manipulation
      // This prevents any timezone or date interpretation issues
      const isoYear = String(year).padStart(4, '0');
      const isoMonth = String(month).padStart(2, '0');
      const isoDay = String(day).padStart(2, '0');
      return `${isoYear}-${isoMonth}-${isoDay}`;
    } else if (dob.includes('-')) {
      // Handle YYYY-MM-DD format
      const parts = dob.split('-');
      if (parts.length === 3) {
        year = parseInt(parts[0], 10);
        month = parseInt(parts[1], 10);
        day = parseInt(parts[2], 10);

        // Validate components
        if (isNaN(year) || isNaN(month) || isNaN(day)) {
          return null;
        }

        // Validate date validity
        if (!isValidDate(year, month, day)) {
          return null;
        }

        if (year < 1900 || year > new Date().getFullYear()) {
          return null;
        }

        // Return as-is if already in YYYY-MM-DD format
        return `${String(year).padStart(4, '0')}-${String(month).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
      }
      return null;
    } else {
      return null;
    }
  } catch (error) {
    return null;
  }
}

function validateDoctorFields(doctorData) {
  if (!doctorData.bio || doctorData.bio.trim() === '') {
    return 'Bio cannot be empty';
  }
  if (doctorData.bio.trim().length < 15) {
    return 'Bio must be at least 15 characters';
  }

  if (!doctorData.location_of_work || doctorData.location_of_work.trim() === '') {
    return 'Location of work cannot be empty';
  }
  if (doctorData.location_of_work.trim().length < 5) {
    return 'Location of work must be at least 5 characters';
  }

  if (!doctorData.degree || doctorData.degree.trim() === '') {
    return 'Degree cannot be empty';
  }
  if (doctorData.degree.trim().length < 5) {
    return 'Degree must be at least 5 characters';
  }

  if (!doctorData.university || doctorData.university.trim() === '') {
    return 'University cannot be empty';
  }
  if (doctorData.university.trim().length < 5) {
    return 'University must be at least 5 characters';
  }

  if (doctorData.certification && doctorData.certification.trim() !== '' && doctorData.certification.trim().length < 5) {
    return 'Certification too short';
  }

  if (doctorData.institution && doctorData.institution.trim() !== '' && doctorData.institution.trim().length < 5) {
    return 'Institution too short';
  }

  if (doctorData.residency && doctorData.residency.trim() !== '' && doctorData.residency.trim().length < 10) {
    return 'Residency too short';
  }

  if (!doctorData.license_number || doctorData.license_number.trim() === '') {
    return 'License number required';
  }
  const licenseRegex = /^\d{4,6}$/;
  if (!licenseRegex.test(doctorData.license_number.trim())) {
    return 'Invalid license number';
  }

  if (doctorData.license_description && doctorData.license_description.trim() !== '' && doctorData.license_description.trim().length < 10) {
    return 'License description too short';
  }

  if (doctorData.years_experience !== null && doctorData.years_experience !== undefined) {
    const years = parseInt(doctorData.years_experience);
    if (isNaN(years) || years < 0 || years > 60) {
      return 'Years of experience invalid';
    }
  }

  if (!doctorData.areas_of_expertise || doctorData.areas_of_expertise.trim() === '') {
    return 'Areas of expertise cannot be empty';
  }
  if (doctorData.areas_of_expertise.trim().length < 10) {
    return 'Areas of expertise too short';
  }

  return null;
}

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

  // Trim all string inputs
  const trimmedEmail = email?.trim() || '';
  const trimmedPassword = password?.trim() || '';
  const trimmedFirstname = firstname?.trim() || '';
  const trimmedLastname = lastname?.trim() || '';
  const trimmedPhone = phone_number?.trim() || '';
  const trimmedNin = nin?.trim() || '';

  // Validate email
  const emailError = validateEmail(trimmedEmail);
  if (emailError) {
    return res.status(400).json({ message: emailError });
  }

  // Validate password
  const passwordError = validatePassword(trimmedPassword);
  if (passwordError) {
    return res.status(400).json({ message: passwordError });
  }

  // Validate firstname
  const firstnameError = validateName(trimmedFirstname, 'First name');
  if (firstnameError) {
    return res.status(400).json({ message: firstnameError });
  }

  // Validate lastname
  const lastnameError = validateName(trimmedLastname, 'Last name');
  if (lastnameError) {
    return res.status(400).json({ message: lastnameError });
  }

  // Validate phone
  const phoneError = validatePhone(trimmedPhone);
  if (phoneError) {
    return res.status(400).json({ message: phoneError });
  }

  // Validate NIN
  const ninError = validateNin(trimmedNin);
  if (ninError) {
    return res.status(400).json({ message: ninError });
  }

  // Validate role - must be 'patient' or 'doctor'
  const userRole = role?.toLowerCase().trim();

  if (!userRole || (userRole !== 'patient' && userRole !== 'doctor')) {
    return res.status(400).json({
      message: 'Invalid role. Must be "patient" or "doctor"'
    });
  }

  // Validate patient-specific fields
  if (userRole === 'patient') {
    if (!date_of_birth) {
      return res.status(400).json({ message: 'Date of birth is required for patients' });
    }
    const dobError = validateDob(date_of_birth);
    if (dobError) {
      return res.status(400).json({ message: dobError });
    }
  }

  // Explicit validation: date_of_birth should NOT be present for doctors
  if (userRole === 'doctor' && date_of_birth) {
    return res.status(400).json({
      message: 'Date of birth should not be provided for doctor signup'
    });
  }

  // Validate doctor-specific fields
  if (userRole === 'doctor') {
    const doctorData = {
      bio: bio?.trim() || '',
      location_of_work: location_of_work?.trim() || '',
      degree: degree?.trim() || '',
      university: university?.trim() || '',
      certification: certification?.trim() || '',
      institution: institution?.trim() || '',
      residency: residency?.trim() || '',
      license_number: license_number?.trim() || '',
      license_description: license_description?.trim() || '',
      years_experience: years_experience,
      areas_of_expertise: areas_of_expertise?.trim() || '',
    };

    const doctorError = validateDoctorFields(doctorData);
    if (doctorError) {
      return res.status(400).json({ message: doctorError });
    }
  }

  // Check if email already exists
  const { data: existingUser } = await supabaseAdmin
    .from('users')
    .select('user_id')
    .eq('email', trimmedEmail)
    .maybeSingle();

  if (existingUser) {
    return res.status(400).json({ message: 'Email already in use' });
  }

  const { data: authUser, error } =
    await supabaseAdmin.auth.admin.createUser({
      email: trimmedEmail,
      password: trimmedPassword,
      email_confirm: true,
    });

  if (error) {
    let msg = error.message?.toLowerCase() || '';
    if (
      msg.includes('already') && (
        msg.includes('email') ||
        msg.includes('registered') ||
        msg.includes('exists') ||
        msg.includes('duplicate')
      )
    ) {
      return res.status(400).json({ message: 'Email already in use' });
    }
    return res.status(400).json({ message: error.message });
  }

  const { data: user, error: userError } = await supabaseAdmin
    .from('users')
    .insert({
      auth_uid: authUser.user.id,
      role: userRole,
      firstname: trimmedFirstname,
      lastname: trimmedLastname,
      email: trimmedEmail,
      phone_number: trimmedPhone,
      nin: trimmedNin,
    })
    .select()
    .single();

  if (userError) {
    return res.status(400).json({ message: userError.message });
  }

  // Handle patient signup
  if (userRole === 'patient') {
    if (!date_of_birth) {
      // Clean up user and auth user if DOB is missing
      await supabaseAdmin.from('users').delete().eq('user_id', user.user_id);
      await supabaseAdmin.auth.admin.deleteUser(authUser.user.id);
      return res.status(400).json({ message: 'Date of birth is required for patients' });
    }

    // Convert date to ISO format (YYYY-MM-DD) for Supabase
    console.log(`[SIGNUP] Original date_of_birth received: "${date_of_birth}"`);
    console.log(`[SIGNUP] Date type: ${typeof date_of_birth}`);

    // Debug: Parse the date manually to verify
    if (date_of_birth.includes('/')) {
      const parts = date_of_birth.split('/');
      console.log(`[SIGNUP] Parsed parts: [0]=${parts[0]} (day), [1]=${parts[1]} (month), [2]=${parts[2]} (year)`);
    }

    const isoDateOfBirth = convertDobToISO(date_of_birth);
    console.log(`[SIGNUP] Converted ISO date: "${isoDateOfBirth}"`);

    if (!isoDateOfBirth) {
      // Clean up user and auth user if date conversion fails
      await supabaseAdmin.from('users').delete().eq('user_id', user.user_id);
      await supabaseAdmin.auth.admin.deleteUser(authUser.user.id);
      return res.status(400).json({ message: 'Invalid date format' });
    }

    // Verify the ISO date format is correct
    const isoDateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!isoDateRegex.test(isoDateOfBirth)) {
      console.error(`[SIGNUP] Invalid ISO date format: ${isoDateOfBirth}`);
      await supabaseAdmin.from('users').delete().eq('user_id', user.user_id);
      await supabaseAdmin.auth.admin.deleteUser(authUser.user.id);
      return res.status(400).json({ message: 'Invalid date format' });
    }

    console.log(`[SIGNUP] Inserting patient with date_of_birth: "${isoDateOfBirth}"`);
    console.log(`[SIGNUP] Date type: ${typeof isoDateOfBirth}`);

    // Ensure we're sending a proper date string to Supabase
    // Supabase expects a date string in YYYY-MM-DD format
    const { error: patientError } = await supabaseAdmin.from('patients').insert({
      patient_id: user.user_id,
      date_of_birth: isoDateOfBirth, // Should be "1999-12-31" format
    });

    if (patientError) {
      console.error(`[SIGNUP] Patient insertion error:`, patientError);
      console.error(`[SIGNUP] Error code: ${patientError.code}`);
      console.error(`[SIGNUP] Error message: ${patientError.message}`);
      console.error(`[SIGNUP] Error details:`, JSON.stringify(patientError, null, 2));
      console.error(`[SIGNUP] Original date input: ${date_of_birth}`);
      console.error(`[SIGNUP] Converted ISO date: ${isoDateOfBirth}`);

      // Clean up user and auth user if patient creation fails
      await supabaseAdmin.from('users').delete().eq('user_id', user.user_id);
      await supabaseAdmin.auth.admin.deleteUser(authUser.user.id);

      // Provide more specific error message for date-related errors
      if (patientError.message && patientError.message.toLowerCase().includes('out of range')) {
        return res.status(400).json({
          message: `Date out of range: The date "${date_of_birth}" (converted to ${isoDateOfBirth}) is invalid. Please check the date format and ensure it's a valid date.`
        });
      }
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
      user_id: user.user_id, // ✅ FIX: Set the foreign key to link doctor to user
      speciality_id: speciality_id || null,
      bio: bio?.trim() || null,
      location_of_work: location_of_work?.trim() || null,
      degree: degree?.trim() || null,
      university: university?.trim() || null,
      certification: certification?.trim() || null,
      institution: institution?.trim() || null,
      residency: residency?.trim() || null,
      license_number: license_number?.trim() || null,
      license_description: license_description?.trim() || null,
      years_experience: years_experience || null,
      areas_of_expertise: areas_of_expertise?.trim() || null,
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
      email: trimmedEmail,
      password: trimmedPassword,
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

  // Trim inputs
  const trimmedEmail = email?.trim() || '';
  const trimmedPassword = password?.trim() || '';

  // Validate email
  const emailError = validateEmail(trimmedEmail);
  if (emailError) {
    return res.status(400).json({ message: emailError });
  }

  // Validate password is not empty
  if (!trimmedPassword || trimmedPassword === '') {
    return res.status(400).json({ message: 'Password cannot be empty' });
  }

  const { data, error } =
    await supabaseAuth.auth.signInWithPassword({
      email: trimmedEmail,
      password: trimmedPassword,
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

export async function uploadProfilePicture(req, res) {
  try {
    console.log('Upload profile picture - req.file:', req.file ? 'exists' : 'missing');
    console.log('Upload profile picture - req.user:', req.user ? 'exists' : 'missing');

    if (!req.file) {
      console.error('No file in request');
      return res.status(400).json({ message: 'No file uploaded' });
    }

    if (!req.user || !req.user.id) {
      console.error('No user in request');
      return res.status(401).json({ message: 'Not authenticated' });
    }

    // Get user from auth middleware
    const userId = req.user.id;

    // Get user_id from users table
    const { data: user, error: userError } = await supabaseAdmin
      .from('users')
      .select('user_id')
      .eq('auth_uid', userId)
      .single();

    if (userError || !user) {
      return res.status(404).json({ message: 'User not found' });
    }

    // Generate unique filename
    const fileExtension = req.file.originalname.split('.').pop().toLowerCase();
    const fileName = `${user.user_id}_${Date.now()}.${fileExtension}`;
    const filePath = `profile-pictures/${fileName}`;

    // Convert buffer to base64 or use buffer directly
    const fileBuffer = req.file.buffer;

    // Determine content type from file extension (more reliable than mimetype from mobile)
    const contentTypeMap = {
      'jpg': 'image/jpeg',
      'jpeg': 'image/jpeg',
      'png': 'image/png',
      'gif': 'image/gif',
      'webp': 'image/webp',
      'bmp': 'image/bmp'
    };
    const contentType = contentTypeMap[fileExtension] || req.file.mimetype || 'image/jpeg';

    console.log('Uploading file - extension:', fileExtension, 'contentType:', contentType, 'original mimetype:', req.file.mimetype);

    // Upload to Supabase Storage
    const { data: uploadData, error: uploadError } = await supabaseAdmin.storage
      .from('profile-pictures')
      .upload(filePath, fileBuffer, {
        contentType: contentType,
        upsert: false,
      });

    if (uploadError) {
      console.error('Upload error:', uploadError);
      return res.status(500).json({
        message: 'Failed to upload profile picture: ' + uploadError.message
      });
    }

    // Get public URL
    const { data: urlData } = supabaseAdmin.storage
      .from('profile-pictures')
      .getPublicUrl(filePath);

    const profilePictureUrl = urlData.publicUrl;

    // Update user record with profile picture URL
    const { error: updateError } = await supabaseAdmin
      .from('users')
      .update({ profile_picture: profilePictureUrl })
      .eq('user_id', user.user_id);

    if (updateError) {
      console.error('Update error:', updateError);
      // Try to delete the uploaded file
      await supabaseAdmin.storage
        .from('profile-pictures')
        .remove([filePath]);

      return res.status(500).json({
        message: 'Failed to update user profile: ' + updateError.message
      });
    }

    res.status(200).json({
      message: 'Profile picture uploaded successfully',
      profile_picture_url: profilePictureUrl,
    });
  } catch (error) {
    console.error('Upload profile picture error:', error);
    // Ensure we always return JSON
    if (!res.headersSent) {
      res.status(500).json({
        message: 'Internal server error: ' + (error.message || 'Unknown error')
      });
    }
  }
}
