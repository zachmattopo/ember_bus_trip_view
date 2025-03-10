import 'package:equatable/equatable.dart';
import 'stop_info.dart';

class TripInfo extends Equatable {
  const TripInfo({
    required this.tripId,
    required this.plateNumber,
    required this.vehicleLatitude,
    required this.vehicleLongitude,
    required this.vehicleHeading,
    required this.vehicleLastUpdated,
    required this.isCancelled,
    required this.stopInfoList,
    required this.nextStop,
    required this.stopTitleText,
  });

  final String tripId;
  final String plateNumber;
  final double vehicleLatitude;
  final double vehicleLongitude;
  final double vehicleHeading;
  final DateTime vehicleLastUpdated;
  final bool isCancelled;
  final List<StopInfo> stopInfoList;
  final StopInfo nextStop;
  final String stopTitleText;

  factory TripInfo.fromJson(Map<String, dynamic> json, String tripId) {
    final stops = (json['route'] as List).map((stop) => StopInfo.fromJson(stop)).toList();
    StopInfo? nextStop;
    try {
      nextStop = stops.firstWhere((stop) => stop.stopStatus == StopStatus.upcoming);
      // ignore: avoid_catching_errors
    } on StateError {
      // Fall back to last stop if no upcoming stop is found.
      nextStop = stops.last;
    }

    return TripInfo(
      tripId: tripId,
      plateNumber: json['vehicle']['plate_number'],
      vehicleLatitude: json['vehicle']['gps']['latitude'],
      vehicleLongitude: json['vehicle']['gps']['longitude'],
      vehicleHeading: json['vehicle']['gps']['heading'].toDouble(),
      vehicleLastUpdated: DateTime.parse(json['vehicle']['gps']['last_updated']).toLocal(),
      isCancelled: json['description']['is_cancelled'],
      stopInfoList: stops,
      nextStop: nextStop,
      stopTitleText: nextStop.stopStatus == StopStatus.upcoming ? 'Next Stop:' : 'Last stop was:',
    );
  }

  @override
  List<Object?> get props => [
    tripId,
    plateNumber,
    vehicleLatitude,
    vehicleLongitude,
    vehicleHeading,
    vehicleLastUpdated,
    isCancelled,
    stopInfoList,
    nextStop,
  ];
}
