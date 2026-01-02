import 'package:afia_plus_app/models/doctor_availability.dart';

/**
 * Abstract interface for Doctor Availability Repository
 * Defines contract for implementing classes using Supabase backend
 */
abstract class DoctorAvailabilityRepository {
  /// Get all availability slots for a doctor
  Future<List<DoctorAvailability>> getDoctorAvailability(int doctorId);

  /// Get availability slots for a date range
  Future<List<DoctorAvailability>> getDoctorAvailabilityByDateRange(
    int doctorId,
    String startDate,
    String endDate,
  );

  /// Get only free slots for a doctor on a specific date
  Future<List<DoctorAvailability>> getFreeSlots(int doctorId, String date);

  /// Create a new availability slot
  Future<DoctorAvailability> createAvailabilitySlot(
    int doctorId,
    String availableDate,
    String startTime,
  );

  /// Bulk create availability slots
  Future<List<DoctorAvailability>> bulkCreateSlots(
    int doctorId,
    List<Map<String, String>> slots,
  );

  /// Update availability slot status (free/booked)
  Future<DoctorAvailability> updateAvailabilityStatus(
    int availabilityId,
    String status,
  );

  /// Delete an availability slot
  Future<void> deleteAvailabilitySlot(int availabilityId);
}
