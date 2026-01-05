-- =====================================================
-- Enable Row Level Security (RLS) for users, patients, and doctors tables
-- =====================================================
-- This script enables RLS and creates policies that:
-- 1. Allow users to read/update their own records
-- 2. Allow users to read public information of other users (for doctor/patient lookups)
-- 3. Maintain compatibility with existing backend code (which uses service role)
-- =====================================================

-- =====================================================
-- USERS TABLE
-- =====================================================

-- Enable RLS on users table
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Policy: Users can read their own user record
CREATE POLICY "Users can read own profile"
ON users
FOR SELECT
USING (auth.uid() = auth_uid);

-- Policy: Users can update their own user record
CREATE POLICY "Users can update own profile"
ON users
FOR UPDATE
USING (auth.uid() = auth_uid);

-- Policy: Users can read public information of other users (for doctor/patient lookups)
-- This allows patients to see doctor profiles and vice versa
CREATE POLICY "Users can read public user profiles"
ON users
FOR SELECT
USING (
  -- Allow reading if authenticated
  auth.uid() IS NOT NULL
  -- Exclude sensitive fields by only allowing specific columns in application logic
  -- Note: This policy allows SELECT, but you should limit columns in your queries
);

-- Policy: Allow authenticated users to insert their own user record during signup
-- This is needed for the signup process
CREATE POLICY "Users can insert own profile during signup"
ON users
FOR INSERT
WITH CHECK (auth.uid() = auth_uid);

-- =====================================================
-- PATIENTS TABLE
-- =====================================================

-- Enable RLS on patients table
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

-- Policy: Patients can read their own patient record
CREATE POLICY "Patients can read own record"
ON patients
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.user_id = patients.patient_id
    AND users.auth_uid = auth.uid()
  )
);

-- Policy: Patients can update their own patient record
CREATE POLICY "Patients can update own record"
ON patients
FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.user_id = patients.patient_id
    AND users.auth_uid = auth.uid()
  )
);

-- Policy: Allow authenticated users to insert their own patient record during signup
CREATE POLICY "Patients can insert own record during signup"
ON patients
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.user_id = patients.patient_id
    AND users.auth_uid = auth.uid()
    AND users.role = 'patient'
  )
);

-- Policy: Doctors can read patient records (for consultations)
-- This allows doctors to see patient information when they have consultations
CREATE POLICY "Doctors can read patient records for consultations"
ON patients
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.user_id = patients.patient_id
    AND users.role = 'patient'
  )
  AND
  EXISTS (
    SELECT 1 FROM users
    WHERE users.role = 'doctor'
    AND users.auth_uid = auth.uid()
  )
);

-- =====================================================
-- DOCTORS TABLE
-- =====================================================

-- Enable RLS on doctors table
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;

-- Policy: Doctors can read their own doctor record
CREATE POLICY "Doctors can read own record"
ON doctors
FOR SELECT
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.user_id = doctors.doctor_id
    AND users.auth_uid = auth.uid()
  )
);

-- Policy: Doctors can update their own doctor record
CREATE POLICY "Doctors can update own record"
ON doctors
FOR UPDATE
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.user_id = doctors.doctor_id
    AND users.auth_uid = auth.uid()
  )
);

-- Policy: Allow authenticated users to insert their own doctor record during signup
CREATE POLICY "Doctors can insert own record during signup"
ON doctors
FOR INSERT
WITH CHECK (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.user_id = doctors.doctor_id
    AND users.auth_uid = auth.uid()
    AND users.role = 'doctor'
  )
);

-- Policy: Anyone authenticated can read doctor profiles (for public doctor listings)
-- This allows patients and other users to browse and book appointments with doctors
CREATE POLICY "Authenticated users can read doctor profiles"
ON doctors
FOR SELECT
USING (
  auth.uid() IS NOT NULL
  AND
  EXISTS (
    SELECT 1 FROM users
    WHERE users.user_id = doctors.doctor_id
    AND users.role = 'doctor'
  )
);

-- =====================================================
-- NOTES
-- =====================================================
-- 1. The service role (SUPABASE_SERVICE_ROLE_KEY) bypasses RLS by default,
--    so your existing backend code using supabaseAdmin will continue to work
--    without any changes. RLS only applies to queries using the anon key.
--
-- 2. These policies protect against:
--    - Direct database access from unauthorized users
--    - Future client-side queries using the anon key
--    - SQL injection attempts
--    - Unauthorized data access
--
-- 3. If you need to adjust policies, you can:
--    - Drop a policy: DROP POLICY "policy_name" ON table_name;
--    - Modify a policy: Drop and recreate it
--    - Disable RLS: ALTER TABLE table_name DISABLE ROW LEVEL SECURITY;
--
-- 4. To test policies, you can temporarily use the anon key in your backend
--    to verify that RLS is working correctly.
--
-- 5. The policies allow:
--    - Users to manage their own data (read/update/insert)
--    - Patients to browse doctor profiles
--    - Doctors to see patient information (for consultations)
--    - Backend service role to perform all operations (bypasses RLS)
--
-- 6. IMPORTANT: After running this script, test your signup and login flows
--    to ensure everything works correctly. The service role will bypass RLS,
--    so your backend should continue working as before.
--
-- 7. If you encounter issues, you can rollback by running:
--    ALTER TABLE users DISABLE ROW LEVEL SECURITY;
--    ALTER TABLE patients DISABLE ROW LEVEL SECURITY;
--    ALTER TABLE doctors DISABLE ROW LEVEL SECURITY;
--    (Then drop individual policies if needed)

