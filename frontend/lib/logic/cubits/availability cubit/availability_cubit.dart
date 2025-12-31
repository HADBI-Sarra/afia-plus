// lib/data/availability_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:afia_plus_app/data/repo/doctor_availability/doctor_availability_abstract.dart';
import 'package:afia_plus_app/data/repo/doctor_availability/doctor_availability_impl.dart';
import 'package:afia_plus_app/data/models/DoctorAvailabilityModel.dart';

part 'availability_state.dart';

/// Model used by UI (grouped by date)
class AvailabilityModel {
  final DateTime date;
  final List<String> times;

  AvailabilityModel({required this.date, required this.times});

  /// Convert list of DoctorAvailabilityModel to grouped AvailabilityModel
  static List<AvailabilityModel> fromDoctorAvailability(
      List<DoctorAvailabilityModel> slots) {
    final Map<String, List<String>> grouped = {};

    for (var slot in slots) {
      if (slot.status.toLowerCase() == 'free') {
        grouped.putIfAbsent(slot.availableDate, () => []);
        grouped[slot.availableDate]!.add(slot.startTime);
      }
    }

    return grouped.entries
        .map((e) => AvailabilityModel(
            date: DateTime.parse(e.key), times: e.value))
        .toList();
  }
}

class AvailabilityCubit extends Cubit<AvailabilityState> {
  final DoctorAvailabilityRepo _repo;

  AvailabilityCubit({DoctorAvailabilityRepo? repo})
      : _repo = repo ?? DoctorAvailabilityImpl(),
        super(AvailabilityInitial());

  /// Load all availability rows for a given doctorId
  Future<void> loadAvailabilityForDoctor(int doctorId) async {
    try {
      emit(AvailabilityLoading());

      // Fetch raw rows from repo (List<Map<String, dynamic>>)
      final rawRows = await _repo.getAvailabilityByDoctor(doctorId);

      // Convert raw maps to DoctorAvailabilityModel instances
      final doctorAvailabilityList = rawRows
          .map((map) => DoctorAvailabilityModel.fromMap(map))
          .toList();

      // Transform into grouped list for UI
      final grouped = AvailabilityModel.fromDoctorAvailability(doctorAvailabilityList);

      // Emit grouped list
      emit(AvailabilityLoaded(grouped, doctorAvailabilityList));
    } catch (e) {
      emit(AvailabilityError('Failed to load availability: $e'));
    }
  }

  /// Add a new availability (doctor side)
  Future<void> addAvailability(Map<String, dynamic> data) async {
    try {
      await _repo.addAvailability(data);
      final doctorId = data['doctor_id'] as int;
      await loadAvailabilityForDoctor(doctorId);
    } catch (e) {
      emit(AvailabilityError('Failed to add availability: $e'));
    }
  }

  /// Update slot status (used when booking to mark booked)
  Future<void> updateSlotStatus(
      int availabilityId, String status, int doctorId) async {
    try {
      await _repo.updateAvailability(availabilityId, {'status': status});
      await loadAvailabilityForDoctor(doctorId);
    } catch (e) {
      emit(AvailabilityError('Failed to update slot: $e'));
    }
  }

  Future<void> addMultipleAvailabilities({
    required int doctorId, required String date, required List<String> times,
  }) async {
    try {
      for (final t in times) {
        await _repo.addAvailability({
          'doctor_id': doctorId,
          'available_date': date,
          'start_time': t,
          'status': 'free',
        });
      }
      await loadAvailabilityForDoctor(doctorId);
    } catch (e) {
      emit(AvailabilityError('Failed to add times: $e'));
    }
  }

  Future<void> deleteAvailabilityById(int availabilityId, int doctorId) async {
    try {
      await _repo.deleteAvailability(availabilityId);
      await loadAvailabilityForDoctor(doctorId);
    } catch (e) {
      emit(AvailabilityError('Failed to delete slot: $e'));
    }
  }

  Future<List<DoctorAvailabilityModel>> getAvailableSlotsForDate(int doctorId, String date) async {
    final rawRows = await _repo.getAvailabilityByDoctor(doctorId);
    final all = rawRows.map((m) => DoctorAvailabilityModel.fromMap(m)).toList();
    return all.where((a) => a.availableDate == date).toList();
  }
}
