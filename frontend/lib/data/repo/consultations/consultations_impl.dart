import 'dart:convert';

import 'package:afia_plus_app/data/api/api_client.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_abstract.dart';
import 'package:afia_plus_app/models/consultation.dart';
import 'package:afia_plus_app/models/consultation_with_details.dart';

/**
 * Consultations Implementation
 * Communicates with backend Supabase through Node.js API
 * Handles booking logic, status transitions, and transaction management
 */
class ConsultationsImpl implements ConsultationsRepository {
  /// Get all consultations for a patient
  @override
  Future<List<ConsultationWithDetails>> getPatientConsultations(
    int patientId,
  ) async {
    try {
      final response = await ApiClient.get('/consultations/patient/$patientId');
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'];
      if (data == null || data is! List) return [];
      return data.map((item) => _mapToConsultationWithDetails(item)).toList();
    } catch (e) {
      throw Exception('Failed to get patient consultations: $e');
    }
  }

  /// Get confirmed consultations for a patient (scheduled or completed)
  @override
  Future<List<ConsultationWithDetails>> getConfirmedPatientConsultations(
    int patientId,
  ) async {
    try {
      final response = await ApiClient.get(
        '/consultations/patient/$patientId/confirmed',
      );
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'];
      if (data == null || data is! List) return [];
      return data.map((item) => _mapToConsultationWithDetails(item)).toList();
    } catch (e) {
      throw Exception('Failed to get confirmed consultations: $e');
    }
  }

  /// Get not confirmed (pending) consultations for a patient
  @override
  Future<List<ConsultationWithDetails>> getNotConfirmedPatientConsultations(
    int patientId,
  ) async {
    try {
      final response = await ApiClient.get(
        '/consultations/patient/$patientId/pending',
      );
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'];
      if (data == null || data is! List) return [];
      return data.map((item) => _mapToConsultationWithDetails(item)).toList();
    } catch (e) {
      throw Exception('Failed to get pending consultations: $e');
    }
  }

  /// Get all consultations for a doctor
  @override
  Future<List<ConsultationWithDetails>> getDoctorConsultations(
    int doctorId,
  ) async {
    try {
      final response = await ApiClient.get('/consultations/doctor/$doctorId');
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'];
      if (data == null || data is! List) return [];
      return data.map((item) => _mapToConsultationWithDetails(item)).toList();
    } catch (e) {
      throw Exception('Failed to get doctor consultations: $e');
    }
  }

  /// Get upcoming consultations for a doctor
  @override
  Future<List<ConsultationWithDetails>> getUpcomingDoctorConsultations(
    int doctorId,
  ) async {
    try {
      print('📋 Fetching upcoming consultations for doctor $doctorId');
      final response = await ApiClient.get(
        '/consultations/doctor/$doctorId/upcoming',
      );
      print('✅ Response status: ${response.statusCode}');
      print('✅ Response body: ${response.body}');

      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'];

      if (data == null) {
        print('⚠️  Data is null, returning empty list');
        return [];
      }

      if (data is! List) {
        print('❌ Data is not a list: ${data.runtimeType}');
        return [];
      }

      return data.map((item) => _mapToConsultationWithDetails(item)).toList();
    } catch (e) {
      print('❌ Error getting upcoming consultations: $e');
      throw Exception('Failed to get upcoming consultations: $e');
    }
  }

  /// Get past consultations for a doctor
  @override
  Future<List<ConsultationWithDetails>> getPastDoctorConsultations(
    int doctorId,
  ) async {
    try {
      final response = await ApiClient.get(
        '/consultations/doctor/$doctorId/past',
      );
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'];
      if (data == null || data is! List) return [];
      return data.map((item) => _mapToConsultationWithDetails(item)).toList();
    } catch (e) {
      throw Exception('Failed to get past consultations: $e');
    }
  }

  /// Get patient prescriptions
  @override
  Future<List<ConsultationWithDetails>> getPatientPrescriptions(
    int patientId,
  ) async {
    try {
      final response = await ApiClient.get(
        '/consultations/patient/$patientId/prescriptions',
      );
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'];
      if (data == null || data is! List) return [];
      return data.map((item) => _mapToConsultationWithDetails(item)).toList();
    } catch (e) {
      throw Exception('Failed to get prescriptions: $e');
    }
  }

  /// Create a new consultation (book a consultation)
  /// This prevents double-booking through backend logic
  @override
  Future<int> createConsultation(Consultation consultation) async {
    try {
      print('📅 Booking consultation:');
      print('  Patient ID: ${consultation.patientId}');
      print('  Doctor ID: ${consultation.doctorId}');
      print('  Availability ID: ${consultation.availabilityId}');
      print('  Date: ${consultation.consultationDate}');
      print('  Time: ${consultation.startTime}');

      final response = await ApiClient.post('/consultations/book', {
        'patientId': consultation.patientId,
        'doctorId': consultation.doctorId,
        'availabilityId': consultation.availabilityId,
        'consultationDate': consultation.consultationDate,
        'startTime': consultation.startTime,
      });

      print('✅ Response status: ${response.statusCode}');
      print('✅ Response body: ${response.body}');

      // Return the created consultation ID
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200 && response.statusCode != 201) {
        final message = jsonData['message'] ?? 'Unknown error';
        throw Exception('Booking failed: $message');
      }

      final createdConsultation = jsonData['data'] as Map<String, dynamic>;
      final consultationId = createdConsultation['consultation_id'] as int;
      print('✅ Created consultation ID: $consultationId');
      return consultationId;
    } catch (e) {
      print('❌ Booking error: $e');
      throw Exception('Failed to book consultation: $e');
    }
  }

  /// Update consultation status
  @override
  Future<void> updateConsultationStatus(
    int consultationId,
    String status,
  ) async {
    try {
      await ApiClient.put('/consultations/$consultationId/status', {
        'status': status,
      });
    } catch (e) {
      throw Exception('Failed to update consultation status: $e');
    }
  }

  /// Update consultation prescription
  @override
  Future<void> updateConsultationPrescription(
    int consultationId,
    String prescription,
  ) async {
    try {
      await ApiClient.post('/consultations/$consultationId/prescription', {
        'prescription': prescription,
      });
    } catch (e) {
      throw Exception('Failed to update prescription: $e');
    }
  }

  /// Delete a consultation (only for pending/cancelled)
  @override
  Future<void> deleteConsultation(int consultationId) async {
    try {
      await ApiClient.delete('/consultations/$consultationId');
    } catch (e) {
      throw Exception('Failed to delete consultation: $e');
    }
  }

  /// Get consultation by ID
  @override
  Future<ConsultationWithDetails?> getConsultationById(
    int consultationId,
  ) async {
    try {
      final response = await ApiClient.get('/consultations/$consultationId');
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'] as Map<String, dynamic>;
      return _mapToConsultationWithDetails(data);
    } catch (e) {
      // Return null if consultation not found
      if (e.toString().contains('404')) {
        return null;
      }
      throw Exception('Failed to get consultation: $e');
    }
  }

  /// Map API response to ConsultationWithDetails model
  ConsultationWithDetails _mapToConsultationWithDetails(
    Map<String, dynamic> data,
  ) {
    // DEBUG: Print the entire data structure
    print('🔍 CONSULTATION DATA: ${data.toString()}');
    print('🔍 Doctor field type: ${data['doctor']?.runtimeType}');
    print('🔍 Doctor field value: ${data['doctor']}');

    // Extract consultation data
    final consultation = Consultation(
      consultationId: data['consultation_id'] as int?,
      patientId: data['patient_id'] as int,
      doctorId: data['doctor_id'] as int,
      availabilityId: data['availability_id'] as int?,
      consultationDate: data['consultation_date'] as String,
      startTime: data['start_time'] as String,
      status: data['status'] as String? ?? 'pending',
      prescription: data['prescription'] as String?,
    );

    // Extract doctor details (from nested object or flat structure)
    String? doctorFirstName;
    String? doctorLastName;
    String? doctorSpecialty;
    String? doctorImagePath;
    String? doctorPhoneNumber;

    // Supabase returns nested relations as arrays, even for single items
    if (data['doctor'] != null) {
      Map<String, dynamic>? doctorData;

      // Handle both array and object responses
      if (data['doctor'] is List && (data['doctor'] as List).isNotEmpty) {
        doctorData = (data['doctor'] as List).first as Map<String, dynamic>;
      } else if (data['doctor'] is Map) {
        doctorData = data['doctor'] as Map<String, dynamic>;
      }

      if (doctorData != null) {
        // Extract user data (also might be array)
        Map<String, dynamic>? userData;
        if (doctorData['user'] is List &&
            (doctorData['user'] as List).isNotEmpty) {
          userData = (doctorData['user'] as List).first as Map<String, dynamic>;
        } else if (doctorData['user'] is Map) {
          userData = doctorData['user'] as Map<String, dynamic>;
        }

        if (userData != null) {
          doctorFirstName = userData['firstname'] as String?;
          doctorLastName = userData['lastname'] as String?;
          doctorImagePath = userData['profile_picture'] as String?;
          doctorPhoneNumber = userData['phone_number'] as String?;
        }

        // Extract speciality data (also might be array)
        Map<String, dynamic>? specialityData;
        if (doctorData['speciality'] is List &&
            (doctorData['speciality'] as List).isNotEmpty) {
          specialityData =
              (doctorData['speciality'] as List).first as Map<String, dynamic>;
        } else if (doctorData['speciality'] is Map) {
          specialityData = doctorData['speciality'] as Map<String, dynamic>;
        }

        if (specialityData != null) {
          doctorSpecialty = specialityData['speciality_name'] as String?;
        }
      }
    } else {
      // Fallback for flat structure
      doctorFirstName = data['doctor_firstname'] as String?;
      doctorLastName = data['doctor_lastname'] as String?;
      doctorSpecialty = data['doctor_specialty'] as String?;
      doctorImagePath = data['doctor_image_path'] as String?;
      doctorPhoneNumber = data['doctor_phone_number'] as String?;
    }

    // Extract patient details
    String? patientFirstName;
    String? patientLastName;
    String? patientPhoneNumber;
    String? patientImagePath;

    // Supabase returns nested relations as arrays, even for single items
    if (data['patient'] != null) {
      Map<String, dynamic>? patientData;

      // Handle both array and object responses
      if (data['patient'] is List && (data['patient'] as List).isNotEmpty) {
        patientData = (data['patient'] as List).first as Map<String, dynamic>;
      } else if (data['patient'] is Map) {
        patientData = data['patient'] as Map<String, dynamic>;
      }

      if (patientData != null) {
        // Extract user data (also might be array)
        Map<String, dynamic>? userData;
        if (patientData['user'] is List &&
            (patientData['user'] as List).isNotEmpty) {
          userData =
              (patientData['user'] as List).first as Map<String, dynamic>;
        } else if (patientData['user'] is Map) {
          userData = patientData['user'] as Map<String, dynamic>;
        }

        if (userData != null) {
          patientFirstName = userData['firstname'] as String?;
          patientLastName = userData['lastname'] as String?;
          patientPhoneNumber = userData['phone_number'] as String?;
          patientImagePath = userData['profile_picture'] as String?;
        }
      }
    } else {
      // Fallback for flat structure
      patientFirstName = data['patient_firstname'] as String?;
      patientLastName = data['patient_lastname'] as String?;
      patientPhoneNumber = data['patient_phone_number'] as String?;
      patientImagePath = data['patient_image_path'] as String?;
    }

    return ConsultationWithDetails(
      consultation: consultation,
      doctorFirstName: doctorFirstName,
      doctorLastName: doctorLastName,
      doctorSpecialty: doctorSpecialty,
      patientFirstName: patientFirstName,
      patientLastName: patientLastName,
      doctorImagePath: doctorImagePath,
      patientImagePath: patientImagePath,
      doctorPhoneNumber: doctorPhoneNumber,
      patientPhoneNumber: patientPhoneNumber,
    );
  }
}
