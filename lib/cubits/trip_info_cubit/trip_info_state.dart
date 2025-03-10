import 'package:equatable/equatable.dart';
import '../../models/trip_info.dart';

abstract class TripInfoState extends Equatable {
  const TripInfoState();

  @override
  List<Object?> get props => [];
}

class TripInfoInitial extends TripInfoState {
  const TripInfoInitial();
}

class TripInfoLoading extends TripInfoState {
  const TripInfoLoading();

  @override
  String toString() => 'TripInfoLoading';
}

class TripInfoSuccess extends TripInfoState {
  const TripInfoSuccess({required this.tripInfo});

  final TripInfo tripInfo;

  @override
  List<Object?> get props => [tripInfo];

  @override
  String toString() => 'TripInfoSuccess { tripInfo: $tripInfo }';
}

class TripInfoFailure extends TripInfoState {
  const TripInfoFailure({required this.errorMessage});

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];

  @override
  String toString() => 'TripInfoFailure { errorMessage: $errorMessage }';
}
