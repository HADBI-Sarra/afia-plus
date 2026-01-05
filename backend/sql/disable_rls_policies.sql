-- =====================================================
-- Disable Row Level Security (RLS) and remove policies
-- =====================================================
-- This script removes all RLS policies and disables RLS
-- Use this if you need to rollback the RLS changes
-- =====================================================

-- =====================================================
-- USERS TABLE
-- =====================================================

-- Drop all policies on users table
DROP POLICY IF EXISTS "Users can read own profile" ON users;
DROP POLICY IF EXISTS "Users can update own profile" ON users;
DROP POLICY IF EXISTS "Users can read public user profiles" ON users;
DROP POLICY IF EXISTS "Users can insert own profile during signup" ON users;

-- Disable RLS on users table
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- =====================================================
-- PATIENTS TABLE
-- =====================================================

-- Drop all policies on patients table
DROP POLICY IF EXISTS "Patients can read own record" ON patients;
DROP POLICY IF EXISTS "Patients can update own record" ON patients;
DROP POLICY IF EXISTS "Patients can insert own record during signup" ON patients;
DROP POLICY IF EXISTS "Doctors can read patient records for consultations" ON patients;

-- Disable RLS on patients table
ALTER TABLE patients DISABLE ROW LEVEL SECURITY;

-- =====================================================
-- DOCTORS TABLE
-- =====================================================

-- Drop all policies on doctors table
DROP POLICY IF EXISTS "Doctors can read own record" ON doctors;
DROP POLICY IF EXISTS "Doctors can update own record" ON doctors;
DROP POLICY IF EXISTS "Doctors can insert own record during signup" ON doctors;
DROP POLICY IF EXISTS "Authenticated users can read doctor profiles" ON doctors;

-- Disable RLS on doctors table
ALTER TABLE doctors DISABLE ROW LEVEL SECURITY;

-- =====================================================
-- NOTES
-- =====================================================
-- After running this script, RLS will be completely disabled
-- and all policies will be removed. Your database will return
-- to its previous state before RLS was enabled.

