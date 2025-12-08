// lib/data/booking_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_impl.dart';
import 'package:afia_plus_app/data/repo/doctor_availability/doctor_availability_impl.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final ConsultationsImpl _consultations;
  final DoctorAvailabilityImpl _availability;

  BookingCubit({ConsultationsImpl? consultations, DoctorAvailabilityImpl? availability})
      : _consultations = consultations ?? ConsultationsImpl(),
        _availability = availability ?? DoctorAvailabilityImpl(),
        super(BookingInitial());

  /// book slot: create consultation and mark availability as booked
  Future<void> book({
    required int patientId,
    required int doctorId,
    required int availabilityId,
    required String consultationDate,
    required String startTime,
  }) async {
    emit(BookingInProgress());
    try {
      // create consultation map consistent with your table
      final data = {
        'patient_id': patientId,
        'doctor_id': doctorId,
        'availability_id': availabilityId,
        'consultation_date': consultationDate,
        'start_time': startTime,
        'status': 'scheduled',
        'prescription': ''
      };

      await _consultations.addConsultation(data);

      // mark availability as booked
      await _availability.updateAvailability(availabilityId, {'status': 'booked'});

      emit(BookingSuccess('Appointment booked'));
    } catch (e) {
      emit(BookingFailure('Failed to book appointment: $e'));
    }
  }
}
