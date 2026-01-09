# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Fixed
- **Doctor Signup Bug**: Fixed missing `user_id` field in doctor signup causing NULL references
  - Updated `backend/controllers/auth.controller.js` to properly set `user_id` when creating doctor accounts
  - This ensures doctor names display correctly in consultations
  - Database fix script created to repair existing 74 doctor accounts with NULL user_id

- **Firebase Configuration**: Moved `firebase-admin` from devDependencies to dependencies in `package.json`
  - Added Firebase environment variable documentation in `.env`
  - Required for push notification functionality

- **Consultation Display**: Enhanced frontend to handle Supabase nested relation responses
  - Added support for both array and object formats from Supabase queries
  - Improved error handling in consultation data mapping

### Added
- **Integration Testing**: Comprehensive integration test suite
  - 77 integration tests covering Authentication, Consultations, and Doctor Availability
  - 171 unit tests for backend services
  - 21 frontend Flutter tests
  - Total: 269 tests across all suites

- **Database Repair Script**: Created `fix_doctor_user_link.js` to repair doctor-user relationships
  - Automatically links doctors with NULL user_id to their corresponding user accounts

## [2026-01-09]

### Testing Summary
- ✅ Backend Unit Tests: 171/171 passing (100%)
- ✅ Backend Integration Tests: 76/77 passing + 1 skipped (100% accounted for)
- ✅ Frontend Tests: 21/21 passing (100%)

### Test Commands
```bash
# Backend unit tests
cd backend
npm run test:unit

# Backend integration tests
npm run test:integration

# Frontend tests
cd frontend
flutter test
```
