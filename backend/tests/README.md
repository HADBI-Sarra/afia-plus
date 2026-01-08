# Unit Testing Documentation

## Overview
Comprehensive test suite for backend functionality covering critical business logic, validation, security, and edge cases. Includes both pure unit tests and integration tests with proper mocking.

## 🎯 Test Statistics

```
Total Test Suites: 9 passing
Total Tests: 171 passing
Execution Time: ~1.3 seconds
Coverage: Unit tests + Integration tests
Framework: Jest 30.2.0 with ES Modules
```

## Test Coverage

### ✅ Core Services (46 tests)

#### 1. Auto-Complete Consultations (`autoCompleteConsultations.test.js`)
- **16 tests** covering:
  - Consultation time calculations (5 tests)
  - Filter logic (2 tests)
  - Edge cases (4 tests)
  - Status update logic (2 tests)
  - Batch processing (3 tests)

#### 2. Consultations Service - Unit (`consultations.service.test.js`)
- **13 tests** covering:
  - Date/time validation logic (3 tests)
  - Time comparison logic (3 tests)
  - Input validation rules (4 tests)
  - Status transition logic (3 tests)

#### 3. Consultations Service - Integration (`consultations.service.integration.test.js`) ⭐ NEW
- **17 tests** covering:
  - Patient consultations CRUD (4 tests)
  - Confirmed consultations filtering (2 tests)
  - Pending consultations filtering (3 tests)
  - Doctor consultations queries (2 tests)
  - Data structure validation (1 test)
  - Edge cases (3 tests)
  - Method verification (2 tests)

### ✅ Security & Middleware (30 tests)

#### 3. Auth Middleware - Unit (`auth.middleware.test.js`)
- **16 tests** covering:
  - Token extraction (4 tests)
  - Authorization header validation (3 tests)
  - HTTP status codes (3 tests)
  - Request object mutation (2 tests)
  - Edge cases (4 tests)

#### 4. Auth Middleware - Integration (`auth.middleware.integration.test.js`) ⭐ NEW
- **14 tests** covering:
  - Real middleware with mocked Supabase (5 tests)
  - Successful authentication flow (3 tests)
  - Edge cases (4 tests)
  - Security validations (2 tests)

### ✅ Business Logic (19 tests)

#### 4. Doctor Availability Service (`doctorAvailability.service.test.js`)
- **19 tests** covering:
  - Date range filtering (3 tests)
  - Slot status filtering (3 tests)
  - Slot sorting (2 tests)
  - Slot creation validation (4 tests)
  - Slot update logic (2 tests)
  - Date validation (3 tests)
  - Edge cases (3 tests)

### ✅ Infrastructure & Utils (76 tests)

#### 5. Response Utils - Unit (`response.utils.test.js`)
- **21 tests** covering:
  - Success response structure (3 tests)
  - Error response structure (3 tests)
  - HTTP status codes (4 tests)
  - Response data formatting (3 tests)
  - Message formatting (3 tests)
  - Response spread operator logic (3 tests)
  - Edge cases (3 tests)

#### 6. Response Utils - Integration (`response.utils.integration.test.js`) ⭐ NEW
- **28 tests** covering:
  - Actual sendResponse function (8 tests)
  - Actual sendError function (8 tests)
  - HTTP status code handling (3 tests)
  - Edge cases (7 tests)
  - Method chaining (2 tests)

#### 7. Job Scheduler (`scheduler.test.js`)
- **24 tests** covering:
  - Job registration (3 tests)
  - Cron expression validation (4 tests)
  - Job lifecycle (3 tests)
  - Timezone configuration (2 tests)
  - Job execution (3 tests)
  - Job list management (4 tests)
  - Graceful shutdown (2 tests)
  - Edge cases (4 tests)

## Coverage Summary Table

| Category | Files Tested | Tests | Status |
|----------|-------------|-------|---------|
| Core Services (Unit) | 2 | 29 | ✅ Complete |
| Core Services (Integration) | 1 | 17 | ✅ Complete |
| Security (Unit) | 1 | 16 | ✅ Complete |
| Security (Integration) | 1 | 14 | ✅ Complete |
| Business Logic | 1 | 19 | ✅ Complete |
| Infrastructure (Unit) | 1 | 21 | ✅ Complete |
| Infrastructure (Integration) | 1 | 28 | ✅ Complete |
| Job Scheduling | 1 | 24 | ✅ Complete |
| **Total** | **9** | **171** | **✅ Complete** |

## Running Tests

### Run all tests
```bash
npm test
```

### Run tests in watch mode (development)
```bash
npm run test:watch
```

### Run tests with coverage report
```bash
npm run test:coverage
```

## Test Configuration

### Jest Configuration (`jest.config.js`)
- **Environment**: Node.js
- **Module Support**: ES Modules (type: module)
- **Test Pattern**: `**/tests/**/*.test.js`
- **Coverage Thresholds**: 70% (branches, functions, lines, statements)

### Test Setup (`tests/setup.js`)
- Mock environment variables
- Global test utilities:
  - `generateRandomEmail()`
  - `generateRandomPhone()`
  - `getFutureDate(daysFromNow)`
  - `getPastDate(daysAgo)`
- Test timeout: 10 seconds

## Mocking Strategy

### Mocked Dependencies
1. **Supabase Client** (`src/config/supabase.js`)
   - All database operations mocked
   - Controlled responses for testing

2. **Logger** (`utils/logger.js`)
   - Silent logging during tests
   - Verify log calls for monitoring

### Mock Patterns
```javascript
// Mock Supabase response
mockSupabase.from.mockReturnValue({
    select: jest.fn().mockReturnValue({
        eq: jest.fn().mockResolvedValue({
            data: [...],
            error: null
        })
    })
});

// Mock Logger
jest.mock('../../utils/logger.js', () => ({
    logger: {
        info: jest.fn(),
        log: jest.fn(),
        error: jest.fn()
    }
}));
```

## Coverage Goals

### Current Coverage Targets (70%)
- **Branches**: 70%
- **Functions**: 70%
- **Lines**: 70%
- **Statements**: 70%

### Covered Areas
1. ✅ Consultation booking logic
2. ✅ Auto-completion job
3. ✅ Auth middleware
4. ✅ Response utilities
5. ✅ Job scheduler
6. ✅ Doctor availability service

## Best Practices

1. **Test Isolation**: Each test is independent, no shared state
2. **Clear Mocks**: All mocks cleared before each test (`beforeEach`)
3. **Descriptive Names**: Test names clearly describe scenario
4. **Edge Cases**: Comprehensive edge case coverage
5. **Async Handling**: Proper async/await usage throughout

## Future Test Additions

### Recommended Next Steps
- Controller integration tests (API endpoints with supertest)
- Database integration tests with test Supabase instance
- Prescription handling tests
- File upload tests (multer)
- E2E tests for complete user workflows

## CI/CD Integration

### Add to GitHub Actions
```yaml
- name: Run Tests
  run: npm test

- name: Upload Coverage
  run: npm run test:coverage
```

## Troubleshooting

### Common Issues

**Issue**: "Cannot use import statement outside a module"
**Solution**: Ensure `"type": "module"` in package.json and use `--experimental-vm-modules` flag

**Issue**: Tests timing out
**Solution**: Increase timeout in jest.config.js or individual tests using `jest.setTimeout()`

**Issue**: Mock not being called
**Solution**: Verify mock is imported before the module under test

## Contributing

When adding new tests:
1. Follow existing patterns and naming conventions
2. Add descriptive test names
3. Include edge cases
4. Update this README with new test coverage
5. Ensure all tests pass before committing

---

**Last Updated**: January 8, 2026
**Total Tests**: 171 (9 test suites)
**Test Types**: Unit Tests (112) + Integration Tests (59)
**Test Execution Time**: ~1.3 seconds
**Status**: ✅ All tests passing
