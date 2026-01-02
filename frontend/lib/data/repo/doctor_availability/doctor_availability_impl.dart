import 'dart:convert';

import 'package:afia_plus_app/data/api/api_client.dart';
import 'package:afia_plus_app/models/doctor_availability.dart';
import 'doctor_availability_abstract.dart';

/**
 * Doctor Availability Implementation
 * Communicates with backend Supabase through Node.js API
 */
class DoctorAvailabilityImpl implements DoctorAvailabilityRepository {
  /// Get all availability slots for a doctor
  @override
  Future<List<DoctorAvailability>> getDoctorAvailability(int doctorId) async {
    try {
      final response = await ApiClient.get('/availability/doctor/$doctorId');
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'] as List;
      return data.map((slot) => DoctorAvailability.fromJson(slot)).toList();
    } catch (e) {
      throw Exception('Failed to get doctor availability: $e');
    }
  }

  /// Get availability slots for a date range
  @override
  Future<List<DoctorAvailability>> getDoctorAvailabilityByDateRange(
    int doctorId,
    String startDate,
    String endDate,
  ) async {
    try {
      final response = await ApiClient.get(
        '/availability/doctor/$doctorId/range?startDate=$startDate&endDate=$endDate',
      );
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'] as List;
      return data.map((slot) => DoctorAvailability.fromJson(slot)).toList();
    } catch (e) {
      throw Exception('Failed to get availability by date range: $e');
    }
  }

  /// Get only free slots for a doctor on a specific date
  @override
  Future<List<DoctorAvailability>> getFreeSlots(
    int doctorId,
    String date,
  ) async {
    try {
      final response = await ApiClient.get(
        '/availability/doctor/$doctorId/free?date=$date',
      );
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'] as List;
      return data.map((slot) => DoctorAvailability.fromJson(slot)).toList();
    } catch (e) {
      throw Exception('Failed to get free slots: $e');
    }
  }

  /// Create a new availability slot
  @override
  Future<DoctorAvailability> createAvailabilitySlot(
    int doctorId,
    String availableDate,
    String startTime,
  ) async {
    try {
      final response = await ApiClient.post('/availability', {
        'doctorId': doctorId,
        'availableDate': availableDate,
        'startTime': startTime,
      });
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return DoctorAvailability.fromJson(jsonData['data']);
    } catch (e) {
      throw Exception('Failed to create availability slot: $e');
    }
  }

  /// Bulk create availability slots
  @override
  Future<List<DoctorAvailability>> bulkCreateSlots(
    int doctorId,
    List<Map<String, String>> slots,
  ) async {
    try {
      final response = await ApiClient.post('/availability/bulk', {
        'doctorId': doctorId,
        'slots': slots,
      });
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'] as List;
      return data.map((slot) => DoctorAvailability.fromJson(slot)).toList();
    } catch (e) {
      throw Exception('Failed to bulk create slots: $e');
    }
  }

  /// Update availability slot status
  @override
  Future<DoctorAvailability> updateAvailabilityStatus(
    int availabilityId,
    String status,
  ) async {
    try {
      final response = await ApiClient.put(
        '/availability/$availabilityId/status',
        {'status': status},
      );
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      return DoctorAvailability.fromJson(jsonData['data']);
    } catch (e) {
      throw Exception('Failed to update availability status: $e');
    }
  }

  /// Delete an availability slot
  @override
  Future<void> deleteAvailabilitySlot(int availabilityId) async {
    try {
      await ApiClient.delete('/availability/$availabilityId');
    } catch (e) {
      throw Exception('Failed to delete availability slot: $e');
    }
  }
}
