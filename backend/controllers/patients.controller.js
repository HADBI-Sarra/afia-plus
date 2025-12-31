import { supabase } from '../src/config/supabase.js';

export async function getMe(req, res) {
  try {
    // Get the current user's auth_uid from the token
    const userAuthUid = req.user.id;
    
    // First, find the user record to get user_id
    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('user_id, *')
      .eq('auth_uid', userAuthUid)
      .single();

    if (userError || !userData) {
      console.error('Error fetching user:', userError);
      return res.status(404).json({ error: 'User not found' });
    }

    // Then get the patient record using the user_id
    const { data: patientData, error: patientError } = await supabase
      .from('patients')
      .select('*')
      .eq('patient_id', userData.user_id)
      .single();

    if (patientError || !patientData) {
      console.error('Error fetching patient:', patientError);
      return res.status(404).json({ error: 'Patient record not found' });
    }

    // Combine user and patient data for the response
    const response = {
      user_id: userData.user_id,
      role: userData.role,
      firstname: userData.firstname,
      lastname: userData.lastname,
      email: userData.email,
      phone_number: userData.phone_number,
      nin: userData.nin,
      profile_picture: userData.profile_picture,
      auth_uid: userData.auth_uid,
      date_of_birth: patientData.date_of_birth,
    };

    res.json(response);
  } catch (error) {
    console.error('getMe exception:', error);
    res.status(500).json({ error: 'Server error' });
  }
}
