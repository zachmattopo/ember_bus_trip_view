import 'package:equatable/equatable.dart';
import '../../models/trip.dart';

abstract class TripListState extends Equatable {
  const TripListState();

  @override
  List<Object?> get props => [];
}

class TripListInitial extends TripListState {
  const TripListInitial();
}

class TripListLoading extends TripListState {
  const TripListLoading();

  @override
  String toString() => 'TripListLoading';
}

class TripListSuccess extends TripListState {
  const TripListSuccess({required this.trips});

  final List<Trip> trips;

  @override
  List<Object?> get props => [trips];

  @override
  String toString() => 'TripListSuccess { trips: $trips }';
}

class TripListFailure extends TripListState {
  const TripListFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  @override
  String toString() => 'TripListFailure { errorMessage: $errorMessage }';
}
