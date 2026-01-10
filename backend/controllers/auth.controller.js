// controllers/auth.controller.js
import { supabaseAdmin, supabaseAuth } from '../src/config/supabase.js';

// Simple in-memory OTP store (email -> full OTP)
// In production, consider using Redis or a database
const otpStore = new Map();

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
      email_confirm: false, // Require email verification
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

  // Send verification email to the user
  // Note: When using admin.createUser, Supabase doesn't automatically send confirmation emails
  // We need to manually trigger it using resend or generateLink
  // IMPORTANT: Email sending is done asynchronously to avoid blocking the signup response
  let otpGenerated = false;
  let storedOtp = null;
  
  try {
    // Use generateLink to get the confirmation email link
    const { data: linkData, error: linkError } = await supabaseAdmin.auth.admin.generateLink({
      type: 'signup',
      email: trimmedEmail,
      options: {
        redirectTo: `${process.env.FRONTEND_URL || 'afia://auth'}`,
      },
    });

    if (linkError || !linkData || !linkData.properties) {
      console.error('Error generating verification OTP:', linkError, linkData);
      console.warn('User created but verification OTP could not be generated.');
    } else {
      // Extract the full OTP token from Supabase
      const fullOtp = linkData.properties.email_otp || '';
      const otpCode = fullOtp.substring(0, 6); // First 6 digits for display in email
      
      if (!fullOtp || fullOtp.length < 6) {
        console.error('Invalid OTP format from Supabase:', fullOtp);
        console.warn('User created but verification OTP is invalid.');
      } else {
        // Store the full OTP token for verification
        // Note: Supabase has its own OTP expiration (5 minutes as configured)
        // We store it with matching expiration - actual expiration validation happens when calling Supabase's verifyOtp
        const OTP_EXPIRY_MS = 5 * 60 * 1000; // 5 minutes (300 seconds) to match Supabase configuration
        otpStore.set(trimmedEmail.toLowerCase(), {
          fullOtp: fullOtp,
          createdAt: Date.now(), // Track when OTP was created for debugging
        });
        
        // Clean up stored OTP after Supabase's default expiration
        setTimeout(() => {
          otpStore.delete(trimmedEmail.toLowerCase());
        }, OTP_EXPIRY_MS);
      
      otpGenerated = true;
      storedOtp = otpCode;
      console.log('✅ Verification OTP generated for:', trimmedEmail);
      
      // Send email asynchronously (non-blocking) to avoid timeout issues
      // This allows the signup response to return immediately while email is sent in background
      (async () => {
        try {
          const { sendEmail } = await import('../utils/sendEmail.js');
          const emailSent = await sendEmail({
            to: trimmedEmail,
            subject: 'Verify your email address - 3afiaPlus',
            html: `
              <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                <h2 style="color: #333;">Welcome to 3afiaPlus!</h2>
                <p>Please use the following 6-digit code to verify your email address:</p>
                <div style="background-color: #f5f5f5; padding: 20px; text-align: center; margin: 20px 0; border-radius: 8px;">
                  <h1 style="font-size: 32px; letter-spacing: 8px; color: #333; margin: 0;">${otpCode}</h1>
                </div>
                <p style="color: #666; font-size: 14px;">This code will expire in 5 minutes.</p>
                <p style="color: #666; font-size: 14px;">If you didn't request this code, please ignore this email.</p>
              </div>
            `
          });
          
          if (emailSent) {
            console.log('✅ Verification email sent successfully to:', trimmedEmail);
          } else {
            console.warn('⚠️ Verification email sending failed for:', trimmedEmail);
            console.warn('⚠️ User can still use resend OTP to receive the code.');
          }
        } catch (err) {
          console.error('Failed to send verification email via nodemailer:', err);
          console.warn('⚠️ User can still use resend OTP to receive the code.');
        }
      })(); // Immediately invoked async function - runs in background
      }
    }
  } catch (emailErr) {
    console.error('Exception generating verification OTP:', emailErr);
    // Continue even if email sending fails - user can request resend later
  }

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

  // Return user data without access token since email is not verified yet
  // Frontend will handle showing verification message
  // OTP is stored and email is being sent in background (non-blocking)
  res.status(200).json({
    user: userData,
    message: otpGenerated 
      ? 'Account created successfully! Please check your email for the verification code.' 
      : 'Account created successfully! Please use "Resend Code" to receive your verification code.',
    email_verified: false,
    otp_sent: otpGenerated,
  });
}

// ---- END signup ----

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
    console.error('[LOGIN] Sign in failed:', error?.message);
    console.error('[LOGIN] Error details:', error);
    
    // Check if it's an email not confirmed error
    if (error?.message && error.message.toLowerCase().includes('email')) {
      return res.status(401).json({
        message: 'Please verify your email before logging in. Check your inbox for the verification code.',
        email_not_verified: true,
      });
    }
    
    return res.status(401).json({
      message: error?.message || 'Invalid credentials',
    });
  }
  
  console.log('[LOGIN] Sign in successful');
  console.log('[LOGIN] User email confirmed at:', data.user.email_confirmed_at);
  
  // CRITICAL: Check if email is verified before allowing login
  // Even if Supabase allows sign-in, we enforce email verification
  if (!data.user.email_confirmed_at) {
    console.warn('[LOGIN] ❌ Login blocked: email not verified for user:', data.user.id);
    // Optionally sign out the user session since we're rejecting the login
    await supabaseAuth.auth.signOut();
    return res.status(403).json({
      message: 'Please verify your email before logging in. Check your inbox for the verification code.',
      email_not_verified: true,
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

  // Include email_confirmed_at from Supabase auth user
  userData.email_confirmed_at = data.user.email_confirmed_at;

  console.log(`[LOGIN] Final response userData keys:`, Object.keys(userData));
  console.log(`[LOGIN] Final response userData.date_of_birth:`, userData.date_of_birth);
  console.log(`[LOGIN] Final response userData.speciality_id:`, userData.speciality_id);
  console.log(`[LOGIN] Final response userData.email_confirmed_at:`, userData.email_confirmed_at);
  
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

  // Get email_confirmed_at from Supabase auth user
  const { data: authUserData, error: authUserError } = await supabaseAdmin.auth.admin.getUserById(req.user.id);
  if (!authUserError && authUserData?.user?.email_confirmed_at) {
    userData.email_confirmed_at = authUserData.user.email_confirmed_at;
  } else if (!userData.email_confirmed_at) {
    // Fallback: if not set, check if email is confirmed
    // If email_confirmed_at is null but user exists, email might not be confirmed
    userData.email_confirmed_at = null;
  }

  console.log(`[ME] Final response userData keys:`, Object.keys(userData));
  console.log(`[ME] Final response userData.date_of_birth:`, userData.date_of_birth);
  console.log(`[ME] Final response userData.speciality_id:`, userData.speciality_id);
  console.log(`[ME] Final response userData.email_confirmed_at:`, userData.email_confirmed_at);
  
  res.json(userData);
}

export async function logout(req, res) {
  res.json({ message: 'Logged out' });
}

export async function verifyOtp(req, res) {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.status(400).json({ message: 'Email and OTP are required' });
  }

  const trimmedEmail = email.trim().toLowerCase();
  const enteredOtp = otp.trim();

  // Validate OTP format (must be exactly 6 digits)
  if (!/^\d{6}$/.test(enteredOtp)) {
    return res.status(400).json({ message: 'OTP must be exactly 6 digits' });
  }

  try {
    // Get stored OTP token (if available) - use full token if stored, otherwise use entered OTP
    // Note: We still check local store for the full token, but Supabase is the source of truth for validity
    const storedOtpData = otpStore.get(trimmedEmail);
    const verifyToken = storedOtpData?.fullOtp || enteredOtp;

    // SINGLE SOURCE OF TRUTH: Supabase verifyOtp
    // Supabase enforces OTP expiration (5 minutes / 300 seconds) - we do NOT check expiration manually
    // If Supabase accepts the OTP, verification is successful - period.
    console.log('[VERIFY] Calling Supabase verifyOtp for email:', trimmedEmail);
    
    const { data, error } = await supabaseAuth.auth.verifyOtp({
      email: email.trim(),
      token: verifyToken,
      type: 'signup',
    });

    // LOG: Supabase verifyOtp response
    console.log('[VERIFY] Supabase verifyOtp response:');
    console.log('  - error:', error ? error.message : 'null');
    console.log('  - user:', data?.user ? `exists (id: ${data.user.id})` : 'null');
    console.log('  - email_confirmed_at:', data?.user?.email_confirmed_at || 'null');
    console.log('  - session:', data?.session ? 'exists' : 'null');

    // If Supabase returned an error, the OTP is invalid or expired
    // Supabase handles expiration - we trust its judgment completely
    if (error) {
      console.log('[VERIFY] RETURN PATH: Error - Supabase rejected OTP');
      
      // Remove OTP from store since verification failed
      if (storedOtpData) {
        otpStore.delete(trimmedEmail);
      }
      
      // Check if it's an expiration error based on Supabase's error message
      const errorMsg = error.message?.toLowerCase() || '';
      const isExpiredError = errorMsg.includes('expired') || errorMsg.includes('expir');
      
      return res.status(400).json({ 
        message: isExpiredError 
          ? 'Verification code has expired. Please request a new code.'
          : (error.message || 'Invalid OTP code'),
        code_expired: isExpiredError,
        verified: false
      });
    }

    // Supabase verifyOtp succeeded - verification is successful
    const supabaseUser = data.user;
    const supabaseSession = data.session;

    if (!supabaseUser) {
      console.log('[VERIFY] RETURN PATH: Error - No user in Supabase response');
      return res.status(400).json({ message: 'Verification failed: User not found', verified: false });
    }

    // CRITICAL: If Supabase returns a user AND email_confirmed_at is set → verification succeeded
    // Return success immediately - do NOT check any local expiration or timestamps
    if (supabaseUser.email_confirmed_at) {
      console.log('[VERIFY] RETURN PATH: SUCCESS - email_confirmed_at is set');
      console.log('[VERIFY] email_confirmed_at value:', supabaseUser.email_confirmed_at);
      
      // Remove OTP from store after successful verification
      if (storedOtpData) {
        otpStore.delete(trimmedEmail);
      }

      // Get user data from our database
      const { data: user, error: userError } = await supabaseAdmin
        .from('users')
        .select('*')
        .eq('auth_uid', supabaseUser.id)
        .single();

      if (userError || !user) {
        console.log('[VERIFY] User not found in database, but Supabase verification succeeded');
        return res.status(404).json({ 
          message: 'User not found',
          verified: false
        });
      }

      // Fetch role-specific data
      let userData = { ...user };
      userData.email_confirmed_at = supabaseUser.email_confirmed_at;

      if (user.role === 'patient') {
        const { data: patient } = await supabaseAdmin
          .from('patients')
          .select('date_of_birth')
          .eq('patient_id', user.user_id)
          .maybeSingle();
        userData.date_of_birth = patient?.date_of_birth ?? null;
      } else if (user.role === 'doctor') {
        const { data: doctor } = await supabaseAdmin
          .from('doctors')
          .select('speciality_id, bio, location_of_work, degree, university, certification, institution, residency, license_number, license_description, years_experience, areas_of_expertise, price_per_hour, average_rating, reviews_count')
          .eq('doctor_id', user.user_id)
          .maybeSingle();
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

      // Return success with session if available
      if (supabaseSession && supabaseSession.access_token) {
        return res.json({
          message: 'Email verified successfully',
          verified: true,
          user: userData,
          access_token: supabaseSession.access_token,
          refresh_token: supabaseSession.refresh_token,
        });
      }

      // If no session but email is confirmed, try to create session using password
      if (!supabaseSession && req.body.password) {
        const { data: loginData, error: loginError } = await supabaseAuth.auth.signInWithPassword({
          email: trimmedEmail,
          password: req.body.password
        });
        
        if (loginError || !loginData.session) {
          return res.json({
            message: 'Email verified successfully, but automatic login failed. Please log in with your email and password.',
            verified: true,
            requires_login: true,
            user: userData,
          });
        }

        return res.json({
          message: 'Email verified and logged in successfully',
          verified: true,
          user: userData,
          access_token: loginData.session.access_token,
          refresh_token: loginData.session.refresh_token,
        });
      }

      // No session and no password - return success but require login
      return res.json({
        message: 'Email verified successfully. Please log in with your email and password.',
        verified: true,
        requires_login: true,
        user: userData,
      });
    }

    // Edge case: Supabase verifyOtp succeeded but email_confirmed_at is null
    // This should not happen in normal flow, but if Supabase accepted the OTP, we treat it as success
    // and manually confirm the email
    console.log('[VERIFY] RETURN PATH: SUCCESS (edge case) - Supabase verifyOtp succeeded but email_confirmed_at is null');
    console.log('[VERIFY] Attempting to manually confirm email...');
    
    const { data: updateData, error: updateError } = await supabaseAdmin.auth.admin.updateUserById(
      supabaseUser.id,
      { email_confirm: true }
    );
    
    if (updateError) {
      console.log('[VERIFY] Manual confirmation failed, but Supabase verifyOtp succeeded - treating as success');
    } else if (updateData?.user?.email_confirmed_at) {
      supabaseUser.email_confirmed_at = updateData.user.email_confirmed_at;
      console.log('[VERIFY] Email confirmed via admin API');
    }

    // Remove OTP from store
    if (storedOtpData) {
      otpStore.delete(trimmedEmail);
    }

    // Get user data and return success (Supabase verifyOtp succeeded, so verification is successful)
    const { data: user, error: userError } = await supabaseAdmin
      .from('users')
      .select('*')
      .eq('auth_uid', supabaseUser.id)
      .single();

    if (userError || !user) {
      return res.status(404).json({ 
        message: 'User not found',
        verified: false
      });
    }

    let userData = { ...user };
    userData.email_confirmed_at = supabaseUser.email_confirmed_at || null;

    if (user.role === 'patient') {
      const { data: patient } = await supabaseAdmin
        .from('patients')
        .select('date_of_birth')
        .eq('patient_id', user.user_id)
        .maybeSingle();
      userData.date_of_birth = patient?.date_of_birth ?? null;
    } else if (user.role === 'doctor') {
      const { data: doctor } = await supabaseAdmin
        .from('doctors')
        .select('speciality_id, bio, location_of_work, degree, university, certification, institution, residency, license_number, license_description, years_experience, areas_of_expertise, price_per_hour, average_rating, reviews_count')
        .eq('doctor_id', user.user_id)
        .maybeSingle();
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

    // Return success - Supabase verifyOtp succeeded
    if (supabaseSession && supabaseSession.access_token) {
      return res.json({
        message: 'Email verified successfully',
        verified: true,
        user: userData,
        access_token: supabaseSession.access_token,
        refresh_token: supabaseSession.refresh_token,
      });
    }

    if (!supabaseSession && req.body.password) {
      const { data: loginData, error: loginError } = await supabaseAuth.auth.signInWithPassword({
        email: trimmedEmail,
        password: req.body.password
      });
      
      if (loginError || !loginData.session) {
        return res.json({
          message: 'Email verified successfully, but automatic login failed. Please log in with your email and password.',
          verified: true,
          requires_login: true,
          user: userData,
        });
      }

      return res.json({
        message: 'Email verified and logged in successfully',
        verified: true,
        user: userData,
        access_token: loginData.session.access_token,
        refresh_token: loginData.session.refresh_token,
      });
    }

    return res.json({
      message: 'Email verified successfully. Please log in with your email and password.',
      verified: true,
      requires_login: true,
      user: userData,
    });
  } catch (error) {
    console.error('[VERIFY] Exception caught:', error);
    return res.status(500).json({ message: 'Internal server error', verified: false });
  }
}

export async function resendOtp(req, res) {
  const { email } = req.body;

  if (!email) {
    return res.status(400).json({ message: 'Email is required' });
  }

  try {
    // Generate new OTP
    const { data: linkData, error: linkError } = await supabaseAdmin.auth.admin.generateLink({
      type: 'signup',
      email: email.trim(),
      options: {
        redirectTo: `${process.env.FRONTEND_URL || 'afia://auth'}`,
      },
    });

    if (linkError || !linkData || !linkData.properties) {
      return res.status(400).json({ message: 'Failed to generate OTP. Please try again.' });
    }

    // Extract the full OTP token from Supabase
    const fullOtp = linkData.properties.email_otp || '';
    const otpCode = fullOtp.substring(0, 6); // First 6 digits for display in email
    
    if (!fullOtp || fullOtp.length < 6) {
      return res.status(400).json({ message: 'Failed to generate valid OTP. Please try again.' });
    }
    
    const trimmedEmail = email.trim().toLowerCase();
    
    // Store the full OTP token for verification
    // Note: Supabase has its own OTP expiration (5 minutes as configured)
    // We store it with matching expiration - actual expiration validation happens when calling Supabase's verifyOtp
    const OTP_EXPIRY_MS = 5 * 60 * 1000; // 5 minutes (300 seconds) to match Supabase configuration
    otpStore.set(trimmedEmail, {
      fullOtp: fullOtp,
      createdAt: Date.now(), // Track when OTP was created for debugging
    });
    
    // Clean up stored OTP after Supabase's default expiration
    setTimeout(() => {
      otpStore.delete(trimmedEmail);
    }, OTP_EXPIRY_MS);

    // Send email with OTP asynchronously (non-blocking) to avoid timeout issues
    // This allows the response to return immediately while email is sent in background
    (async () => {
      try {
        const { sendEmail } = await import('../utils/sendEmail.js');
        const emailSent = await sendEmail({
          to: email.trim(),
          subject: 'Verify your email address - 3afiaPlus',
          html: `
            <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
              <h2 style="color: #333;">Welcome to 3afiaPlus!</h2>
              <p>Please use the following 6-digit code to verify your email address:</p>
              <div style="background-color: #f5f5f5; padding: 20px; text-align: center; margin: 20px 0; border-radius: 8px;">
                <h1 style="font-size: 32px; letter-spacing: 8px; color: #333; margin: 0;">${otpCode}</h1>
              </div>
              <p style="color: #666; font-size: 14px;">This code will expire in 5 min.</p>
              <p style="color: #666; font-size: 14px;">If you didn't request this code, please ignore this email.</p>
            </div>
          `
        });

        if (emailSent) {
          console.log('✅ Resend OTP email sent successfully to:', email.trim());
        } else {
          console.warn('⚠️ Resend OTP email sending failed for:', email.trim());
        }
      } catch (err) {
        console.error('Failed to send resend OTP email:', err);
      }
    })(); // Immediately invoked async function - runs in background

    // Return immediately - email is being sent in background
    // OTP is already stored, so user can try entering it even if email hasn't arrived yet
    res.json({ message: 'OTP code sent successfully. Please check your email.' });
  } catch (error) {
    console.error('Error resending OTP:', error);
    res.status(500).json({ message: 'Internal server error' });
  }
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
