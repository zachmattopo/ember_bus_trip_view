import 'package:ember_bus_trip_view/models/stop_info.dart';
import 'package:ember_bus_trip_view/models/trip_info.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/mock_test_data.dart';

void main() {
  const mockTripId = 'test_trip_123';

  group('TripInfo', () {
    test('fromJson creates TripInfo with correct values', () {
      // Arrange
      final json = MockTestData.mockTripInfoJson;

      // Act
      final tripInfo = TripInfo.fromJson(json, mockTripId);

      // Assert
      expect(tripInfo.tripId, equals(mockTripId));
      expect(tripInfo.plateNumber, equals('SG24 UHB'));
      expect(tripInfo.vehicleLatitude, equals(57.18646));
      expect(tripInfo.vehicleLongitude, equals(-2.0918733));
      expect(tripInfo.vehicleHeading, equals(92.0));
      expect(
        tripInfo.vehicleLastUpdated,
        equals(DateTime.parse('2025-03-10T06:59:35.271000+00:00').toLocal()),
      );
      expect(tripInfo.isCancelled, equals(false));
      expect(tripInfo.stopInfoList, isNotEmpty);
    });

    test('sets nextStop to last stop when no upcoming stops exist', () {
      // Arrange
      final json = Map<String, dynamic>.from(MockTestData.mockTripInfoJson);
      json['route'] = List<Map<String, dynamic>>.from(json['route']);
      final routeList =
          (json['route'] as List).map((stop) {
            final stopMap = Map<String, dynamic>.from(stop);
            // Make all stops past
            stopMap['arrival']['actual'] = '2025-03-10T00:00:00Z';
            return stopMap;
          }).toList();
      json['route'] = routeList;

      // Act
      final tripInfo = TripInfo.fromJson(json, mockTripId);

      // Assert
      expect(tripInfo.nextStop, isNotNull);
      expect(tripInfo.nextStop.stopStatus, equals(StopStatus.past));
      expect(tripInfo.stopTitleText, equals('Last stop was:'));
    });

    test('props contains all properties', () {
      // Arrange
      final tripInfo = TripInfo(
        tripId: mockTripId,
        plateNumber: 'TEST123',
        vehicleLatitude: 55,
        vehicleLongitude: -3,
        vehicleHeading: 90,
        vehicleLastUpdated: DateTime.now(),
        isCancelled: false,
        stopInfoList: const [],
        nextStop: StopInfo(
          detailedName: 'Test Stop',
          regionName: 'Test Region',
          lat: 55,
          lon: -3,
          skipped: false,
          scheduledTime: DateTime.now(),
          stopStatus: StopStatus.upcoming,
          isOnTime: true,
        ),
        stopTitleText: 'Next Stop:',
      );

      // Assert
      expect(
        tripInfo.props,
        equals([
          tripInfo.tripId,
          tripInfo.plateNumber,
          tripInfo.vehicleLatitude,
          tripInfo.vehicleLongitude,
          tripInfo.vehicleHeading,
          tripInfo.vehicleLastUpdated,
          tripInfo.isCancelled,
          tripInfo.stopInfoList,
          tripInfo.nextStop,
        ]),
      );
    });
  });
}
