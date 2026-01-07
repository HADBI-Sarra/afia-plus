import { supabaseAdmin } from '../src/config/supabase.js';

export async function getMe(req, res) {
  const { data: user } = await supabaseAdmin
    .from('users')
    .select('*')
    .eq('auth_uid', req.user.id)
    .maybeSingle();

  if (!user) {
    return res.status(404).json({ message: 'User not found' });
  }

  const { data: doctor } = await supabaseAdmin
    .from('doctors')
    .select('speciality_id, bio, location_of_work, degree, university, certification, institution, residency, license_number, license_description, years_experience, areas_of_expertise, price_per_hour, average_rating, reviews_count')
    .eq('doctor_id', user.user_id)
    .maybeSingle();

  res.json({
    ...user,
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
  });
}

// Returns all specialities for popular specializations on home
export async function getSpecialities(req, res) {
  // Get all specialities
  const { data, error } = await supabaseAdmin
    .from('specialities')
    .select('speciality_id, speciality_name');
  if (error) {
    return res.status(500).json({ message: error.message });
  }
  res.json(data ?? []);
}

// Returns all doctors for a given speciality (for home specializations section)
export async function getDoctorsBySpeciality(req, res) {
  const { speciality_id } = req.query;
  if (!speciality_id) {
    return res.status(400).json({ message: 'Missing speciality_id' });
  }
  const { data, error } = await supabaseAdmin
    .from('doctors')
    .select('doctor_id, speciality_id, bio, location_of_work, degree, university, certification, institution, residency, license_number, license_description, years_experience, areas_of_expertise, price_per_hour, average_rating, reviews_count, user:user_id(firstname, lastname, email, phone_number, profile_picture)')
    .eq('speciality_id', speciality_id);

  if (error) {
    return res.status(500).json({ message: error.message });
  }
  res.json(data ?? []);
}

