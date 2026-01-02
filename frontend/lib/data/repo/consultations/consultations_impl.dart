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
      final data = jsonData['data'] as List;
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
      final data = jsonData['data'] as List;
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
      final data = jsonData['data'] as List;
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
      final data = jsonData['data'] as List;
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
      final response = await ApiClient.get(
        '/consultations/doctor/$doctorId/upcoming',
      );
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final data = jsonData['data'] as List;
      return data.map((item) => _mapToConsultationWithDetails(item)).toList();
    } catch (e) {
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
      final data = jsonData['data'] as List;
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
      final data = jsonData['data'] as List;
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
      final response = await ApiClient.post('/consultations/book', {
        'patientId': consultation.patientId,
        'doctorId': consultation.doctorId,
        'availabilityId': consultation.availabilityId,
        'consultationDate': consultation.consultationDate,
        'startTime': consultation.startTime,
      });

      // Return the created consultation ID
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final createdConsultation = jsonData['data'] as Map<String, dynamic>;
      return createdConsultation['consultation_id'] as int;
    } catch (e) {
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

    if (data['doctor'] is Map) {
      final doctorData = data['doctor'] as Map<String, dynamic>;
      final userData = doctorData['user'] as Map<String, dynamic>?;
      final specialityData = doctorData['speciality'] as Map<String, dynamic>?;

      if (userData != null) {
        doctorFirstName = userData['firstname'] as String?;
        doctorLastName = userData['lastname'] as String?;
        doctorImagePath = userData['profile_picture'] as String?;
        doctorPhoneNumber = userData['phone_number'] as String?;
      }

      if (specialityData != null) {
        doctorSpecialty = specialityData['speciality_name'] as String?;
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

    if (data['patient'] is Map) {
      final patientData = data['patient'] as Map<String, dynamic>;
      final userData = patientData['user'] as Map<String, dynamic>?;

      if (userData != null) {
        patientFirstName = userData['firstname'] as String?;
        patientLastName = userData['lastname'] as String?;
        patientPhoneNumber = userData['phone_number'] as String?;
      }
    } else {
      // Fallback for flat structure
      patientFirstName = data['patient_firstname'] as String?;
      patientLastName = data['patient_lastname'] as String?;
      patientPhoneNumber = data['patient_phone_number'] as String?;
    }

    return ConsultationWithDetails(
      consultation: consultation,
      doctorFirstName: doctorFirstName,
      doctorLastName: doctorLastName,
      doctorSpecialty: doctorSpecialty,
      patientFirstName: patientFirstName,
      patientLastName: patientLastName,
      doctorImagePath: doctorImagePath,
      doctorPhoneNumber: doctorPhoneNumber,
      patientPhoneNumber: patientPhoneNumber,
    );
  }
}
