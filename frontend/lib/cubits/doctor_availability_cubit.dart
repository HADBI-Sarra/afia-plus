import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:afia_plus_app/data/repo/doctor_availability/doctor_availability_impl.dart';
import 'package:afia_plus_app/models/doctor_availability.dart';

/**
 * Doctor Availability Cubit State
 */
class DoctorAvailabilityState {
  final List<DoctorAvailability> availabilitySlots;
  final bool isLoading;
  final String? error;
  final Set<int> processingSlotIds; // Track which slots are being processed

  DoctorAvailabilityState({
    this.availabilitySlots = const [],
    this.isLoading = false,
    this.error,
    this.processingSlotIds = const {},
  });

  DoctorAvailabilityState copyWith({
    List<DoctorAvailability>? availabilitySlots,
    bool? isLoading,
    String? error,
    Set<int>? processingSlotIds,
  }) {
    return DoctorAvailabilityState(
      availabilitySlots: availabilitySlots ?? this.availabilitySlots,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      processingSlotIds: processingSlotIds ?? this.processingSlotIds,
    );
  }
}

/**
 * Doctor Availability Cubit
 * Manages doctor availability slot creation, deletion, and retrieval
 * Handles slot management for the doctor's schedule
 */
class DoctorAvailabilityCubit extends Cubit<DoctorAvailabilityState> {
  final DoctorAvailabilityImpl _repository;

  DoctorAvailabilityCubit({DoctorAvailabilityImpl? repository})
    : _repository = repository ?? DoctorAvailabilityImpl(),
      super(DoctorAvailabilityState());

  /// Load all availability slots for a doctor
  Future<void> loadDoctorAvailability(int doctorId) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final slots = await _repository.getDoctorAvailability(doctorId);
      emit(state.copyWith(availabilitySlots: slots, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Load availability slots for a specific date range
  Future<void> loadAvailabilityByDateRange(
    int doctorId,
    String startDate,
    String endDate,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final slots = await _repository.getDoctorAvailabilityByDateRange(
        doctorId,
        startDate,
        endDate,
      );
      emit(state.copyWith(availabilitySlots: slots, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Load only free (unbooked) slots for a specific date
  Future<void> loadFreeSlots(int doctorId, String date) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final slots = await _repository.getFreeSlots(doctorId, date);
      emit(state.copyWith(availabilitySlots: slots, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Create a single availability slot
  Future<void> createAvailabilitySlot(
    int doctorId,
    String availableDate,
    String startTime,
  ) async {
    try {
      final slot = await _repository.createAvailabilitySlot(
        doctorId,
        availableDate,
        startTime,
      );

      // Add the new slot to the list
      emit(
        state.copyWith(availabilitySlots: [...state.availabilitySlots, slot]),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  /// Create multiple availability slots at once (bulk operation)
  /// slots: List of maps with 'date' and 'startTime' keys
  /// Example: [{'date': '2024-01-15', 'startTime': '09:00'}, ...]
  Future<void> createMultipleSlots(
    int doctorId,
    List<Map<String, String>> slots,
  ) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final createdSlots = await _repository.bulkCreateSlots(doctorId, slots);

      // Add all new slots to the list
      emit(
        state.copyWith(
          availabilitySlots: [...state.availabilitySlots, ...createdSlots],
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  /// Delete an availability slot
  Future<void> deleteSlot(int availabilityId) async {
    try {
      // Add to processing set
      emit(
        state.copyWith(
          processingSlotIds: {...state.processingSlotIds, availabilityId},
        ),
      );

      await _repository.deleteAvailabilitySlot(availabilityId);

      // Remove the slot from the list
      final updated = state.availabilitySlots
          .where((s) => s.availabilityId != availabilityId)
          .toList();

      final newProcessingSet = Set<int>.from(state.processingSlotIds)
        ..remove(availabilityId);

      emit(
        state.copyWith(
          availabilitySlots: updated,
          processingSlotIds: newProcessingSet,
        ),
      );
    } catch (e) {
      final newProcessingSet = Set<int>.from(state.processingSlotIds)
        ..remove(availabilityId);
      emit(
        state.copyWith(
          error: e.toString(),
          processingSlotIds: newProcessingSet,
        ),
      );
    }
  }

  /// Update slot status (free <-> booked)
  Future<void> updateSlotStatus(int availabilityId, String status) async {
    try {
      // Add to processing set
      emit(
        state.copyWith(
          processingSlotIds: {...state.processingSlotIds, availabilityId},
        ),
      );

      final updatedSlot = await _repository.updateAvailabilityStatus(
        availabilityId,
        status,
      );

      // Update the slot in the list
      final updated = state.availabilitySlots.map((s) {
        if (s.availabilityId == availabilityId) {
          return updatedSlot;
        }
        return s;
      }).toList();

      final newProcessingSet = Set<int>.from(state.processingSlotIds)
        ..remove(availabilityId);

      emit(
        state.copyWith(
          availabilitySlots: updated,
          processingSlotIds: newProcessingSet,
        ),
      );
    } catch (e) {
      final newProcessingSet = Set<int>.from(state.processingSlotIds)
        ..remove(availabilityId);
      emit(
        state.copyWith(
          error: e.toString(),
          processingSlotIds: newProcessingSet,
        ),
      );
    }
  }

  /// Get available slots for a specific date
  List<DoctorAvailability> getAvailableSlotsForDate(String date) {
    return state.availabilitySlots
        .where((slot) => slot.availableDate == date && slot.status == 'free')
        .toList();
  }

  /// Get all booked slots for a doctor
  List<DoctorAvailability> getBookedSlots() {
    return state.availabilitySlots
        .where((slot) => slot.status == 'booked')
        .toList();
  }

  /// Get free slots count
  int getFreeSlotCount() {
    return state.availabilitySlots
        .where((slot) => slot.status == 'free')
        .length;
  }

  /// Clear error message
  void clearError() {
    emit(state.copyWith(error: null));
  }

  /// Refresh availability data
  Future<void> refreshAvailability(int doctorId) async {
    await loadDoctorAvailability(doctorId);
  }
}
