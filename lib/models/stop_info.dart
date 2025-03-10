import 'package:equatable/equatable.dart';

enum StopStatus { past, upcoming }

class StopInfo extends Equatable {
  const StopInfo({
    required this.detailedName,
    required this.regionName,
    required this.lat,
    required this.lon,
    required this.skipped,
    required this.scheduledTime,
    required this.stopStatus,
    required this.isOnTime,
    this.actualTime,
    this.estimatedTime,
    this.googlePlaceId,
  });

  final String detailedName;
  final String regionName;
  final double lat;
  final double lon;
  final bool skipped;
  final DateTime scheduledTime;
  final DateTime? actualTime;
  final DateTime? estimatedTime;
  final String? googlePlaceId;
  final StopStatus stopStatus;
  final bool isOnTime;

  factory StopInfo.fromJson(Map<String, dynamic> json) {
    final scheduledTime = DateTime.parse(json['arrival']['scheduled']).toLocal();
    final hasActualTime = json['arrival']['actual'] != null;
    final actualTime = hasActualTime ? DateTime.parse(json['arrival']['actual']).toLocal() : null;
    final estimatedTime =
        json['arrival']['estimated'] != null
            ? DateTime.parse(json['arrival']['estimated']).toLocal()
            : null;
    // [isOnTime] is true, if actual time is earlier than or same as scheduled time,
    // OR (if actual is null) estimated time is earlier than or same as scheduled time.
    final isOnTime =
        (actualTime != null && actualTime.isBefore(scheduledTime) ||
            estimatedTime != null && estimatedTime.isBefore(scheduledTime)) ||
        (actualTime != null &&
                scheduledTime.year == actualTime.year &&
                scheduledTime.month == actualTime.month &&
                scheduledTime.day == actualTime.day &&
                scheduledTime.hour == actualTime.hour &&
                scheduledTime.minute == actualTime.minute ||
            estimatedTime != null &&
                scheduledTime.year == estimatedTime.year &&
                scheduledTime.month == estimatedTime.month &&
                scheduledTime.day == estimatedTime.day &&
                scheduledTime.hour == estimatedTime.hour &&
                scheduledTime.minute == estimatedTime.minute);

    return StopInfo(
      detailedName: json['location']['detailed_name'],
      regionName: json['location']['region_name'],
      lat: json['location']['lat'].toDouble(),
      lon: json['location']['lon'].toDouble(),
      skipped: json['skipped'],
      scheduledTime: scheduledTime,
      actualTime: actualTime,
      estimatedTime: estimatedTime,
      googlePlaceId: json['location']['google_place_id'],
      // Stop status is determined by the following rules:
      // 1. If arrival's actual time exists, then the stop is in the past.
      // 2. In case actual time is not returned in API response, the workaround:
      // If the current time is after estimated time, then assume the stop is in the past.
      stopStatus:
          hasActualTime || (estimatedTime != null && DateTime.now().isAfter(estimatedTime))
              ? StopStatus.past
              : StopStatus.upcoming,
      isOnTime: isOnTime,
    );
  }

  @override
  List<Object?> get props => [
    detailedName,
    regionName,
    lat,
    lon,
    skipped,
    scheduledTime,
    actualTime,
    estimatedTime,
    googlePlaceId,
    stopStatus,
    isOnTime,
  ];
}
