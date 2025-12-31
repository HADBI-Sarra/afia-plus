// lib/data/booking_state.dart
part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingInProgress extends BookingState {}

class BookingSuccess extends BookingState {
  final String message;
  BookingSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class BookingFailure extends BookingState {
  final String message;
  BookingFailure(this.message);

  @override
  List<Object?> get props => [message];
}
