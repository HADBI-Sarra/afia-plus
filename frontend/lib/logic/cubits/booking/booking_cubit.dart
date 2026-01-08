// lib/data/booking_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:afia_plus_app/data/repo/consultations/consultations_impl.dart';
import 'package:afia_plus_app/models/consultation.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final ConsultationsImpl _consultations;

  BookingCubit({ConsultationsImpl? consultations})
    : _consultations = consultations ?? ConsultationsImpl(),
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
      print('🔹 BookingCubit: Starting booking process...');
      final newConsultation = Consultation(
        patientId: patientId,
        doctorId: doctorId,
        availabilityId: availabilityId,
        consultationDate: consultationDate,
        startTime: startTime,
        // Create as pending so the doctor can confirm
        status: 'pending',
        prescription: '',
      );

      final consultationId = await _consultations.createConsultation(
        newConsultation,
      );
      print('🔹 BookingCubit: Consultation created with ID: $consultationId');

      // mark availability as booked - done automatically by backend
      // availability status is updated when consultation is created
      emit(BookingSuccess('Appointment booked successfully!'));
      print('🔹 BookingCubit: Success emitted');
    } catch (e) {
      print('🔹 BookingCubit: Error - $e');
      emit(BookingFailure('Failed to book appointment: $e'));
    }
  }
}
