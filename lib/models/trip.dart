import 'package:equatable/equatable.dart';

enum TripStatus { past, active, upcoming }

class Trip extends Equatable {
  const Trip({
    required this.tripUid,
    required this.scheduledDeparture,
    required this.numberPlate,
    required this.tripStatus,
  });

  final String tripUid;
  final DateTime scheduledDeparture;
  final String numberPlate;
  final TripStatus tripStatus;

  factory Trip.fromJson(Map<String, dynamic> json) {
    final legs = json['legs'] as List;
    final firstLeg = legs.first;
    final departure = firstLeg['departure'];
    final arrival = firstLeg['arrival'];

    final hasActualDeparture = departure['actual'] != null;
    final hasActualArrival = arrival['actual'] != null;

    final tripStatus =
        hasActualArrival && hasActualDeparture
            ? TripStatus.past
            : hasActualDeparture
            ? TripStatus.active
            : TripStatus.upcoming;

    return Trip(
      tripUid: firstLeg['trip_uid'],
      scheduledDeparture: DateTime.parse(firstLeg['departure']['scheduled']).toLocal(),
      numberPlate: firstLeg['description']['number_plate'],
      tripStatus: tripStatus,
    );
  }

  @override
  List<Object?> get props => [tripUid, scheduledDeparture, numberPlate, tripStatus];
}
