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

// Returns top 4 specialities with doctor counts for popular specializations on home
// If ?all=true is passed, returns all specialities with doctor counts
export async function getSpecialities(req, res) {
  try {
    const { all } = req.query;
    const limit = all === 'true' ? undefined : 4;

    // Get all doctors with their speciality_id
    const { data: doctors, error: doctorsError } = await supabaseAdmin
      .from('doctors')
      .select('speciality_id');

    if (doctorsError) {
      return res.status(500).json({ message: doctorsError.message });
    }

    if (!doctors || doctors.length === 0) {
      return res.json([]);
    }

    // Count doctors per speciality
    const specialityCounts = {};
    doctors.forEach(doctor => {
      if (doctor.speciality_id) {
        specialityCounts[doctor.speciality_id] = (specialityCounts[doctor.speciality_id] || 0) + 1;
      }
    });

    // Get speciality IDs that have doctors, sorted by count (descending)
    let specialityIds = Object.keys(specialityCounts)
      .map(id => parseInt(id))
      .sort((a, b) => specialityCounts[b] - specialityCounts[a]);

    // Limit to top 4 if not requesting all
    if (limit) {
      specialityIds = specialityIds.slice(0, limit);
    }

    if (specialityIds.length === 0) {
      return res.json([]);
    }

    // Fetch speciality details
    const { data: specialities, error: specialitiesError } = await supabaseAdmin
      .from('specialities')
      .select('speciality_id, speciality_name')
      .in('speciality_id', specialityIds);

    if (specialitiesError) {
      return res.status(500).json({ message: specialitiesError.message });
    }

    // Combine with counts and maintain order
    const result = specialityIds.map(id => {
      const speciality = specialities.find(s => s.speciality_id === id);
      return {
        speciality_id: id,
        speciality_name: speciality?.speciality_name || '',
        doctor_count: specialityCounts[id]
      };
    }).filter(item => item.speciality_name); // Remove any that don't have a name

    res.json(result);
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
}

// Returns all doctors for a given speciality (for home specializations section)
export async function getDoctorsBySpeciality(req, res) {
  const { speciality_id } = req.query;
  if (!speciality_id) {
    return res.status(400).json({ message: 'Missing speciality_id' });
  }

  // Parse speciality_id to integer
  const specialityIdInt = parseInt(speciality_id, 10);
  if (isNaN(specialityIdInt)) {
    return res.status(400).json({ message: 'Invalid speciality_id' });
  }

  try {
    // Get speciality name first
    const { data: specialityData, error: specialityError } = await supabaseAdmin
      .from('specialities')
      .select('speciality_name')
      .eq('speciality_id', specialityIdInt)
      .maybeSingle();

    if (specialityError) {
      return res.status(500).json({ message: specialityError.message });
    }

    // Get all doctors with the given speciality_id
    const { data: doctors, error: doctorsError } = await supabaseAdmin
      .from('doctors')
      .select('doctor_id, speciality_id, bio, location_of_work, degree, university, certification, institution, residency, license_number, license_description, years_experience, areas_of_expertise, price_per_hour, average_rating, reviews_count')
      .eq('speciality_id', specialityIdInt);

    if (doctorsError) {
      return res.status(500).json({ message: doctorsError.message });
    }

    if (!doctors || doctors.length === 0) {
      return res.json([]);
    }

    // Get user_id values from doctors (doctor_id = user_id)
    const userIds = doctors.map(d => d.doctor_id);

    // Fetch user information for these doctors
    const { data: users, error: usersError } = await supabaseAdmin
      .from('users')
      .select('user_id, firstname, lastname, email, phone_number, profile_picture')
      .in('user_id', userIds);

    if (usersError) {
      return res.status(500).json({ message: usersError.message });
    }

    // Combine doctor and user data
    const result = doctors.map(doctor => {
      const user = users.find(u => u.user_id === doctor.doctor_id);
      return {
        ...doctor,
        firstname: user?.firstname || null,
        lastname: user?.lastname || null,
        email: user?.email || null,
        phone_number: user?.phone_number || null,
        profile_picture: user?.profile_picture || null,
        speciality_name: specialityData?.speciality_name || null
      };
    });

    res.json(result);
  } catch (error) {
    return res.status(500).json({ message: error.message });
  }
}

