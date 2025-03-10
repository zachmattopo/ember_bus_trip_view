import 'package:ember_bus_trip_view/models/stop_info.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mock/mock_test_data.dart';

void main() {
  group('StopInfo', () {
    test('fromJson creates StopInfo with correct basic values', () {
      // Arrange
      final json = MockTestData.mockTripInfoJson['route'][0];

      // Act
      final stopInfo = StopInfo.fromJson(json);

      // Assert
      expect(stopInfo.detailedName, equals('Bridge of Don Depot'));
      expect(stopInfo.regionName, equals('Aberdeen'));
      expect(stopInfo.lat, equals(57.18653578702499));
      expect(stopInfo.lon, equals(-2.0920950563527385));
      expect(stopInfo.skipped, equals(false));
      expect(stopInfo.scheduledTime, equals(DateTime.parse('2025-03-09T22:42:00+00:00').toLocal()));
    });

    group('stopStatus', () {
      test('returns past when actual arrival time exists', () {
        // Arrange
        final json = MockTestData.mockTripInfoJson['route'][0];

        // Act
        final stopInfo = StopInfo.fromJson(json);

        // Assert
        expect(stopInfo.stopStatus, equals(StopStatus.past));
      });

      test('returns upcoming when no actual arrival time exists', () {
        // Arrange
        final json = {
          'location': {
            'detailed_name': 'Test Stop',
            'region_name': 'Test Region',
            'lat': 55.0,
            'lon': -3.0,
          },
          'arrival': {'scheduled': '2025-03-09T22:42:00+00:00'},
          'skipped': false,
        };

        // Act
        final stopInfo = StopInfo.fromJson(json);

        // Assert
        expect(stopInfo.stopStatus, equals(StopStatus.upcoming));
      });
    });

    group('isOnTime', () {
      test('returns true when actual time is before scheduled time', () {
        // Arrange
        final json = {
          'location': {
            'detailed_name': 'Test Stop',
            'region_name': 'Test Region',
            'lat': 55.0,
            'lon': -3.0,
          },
          'arrival': {
            'scheduled': '2025-03-09T22:42:00+00:00',
            'actual': '2025-03-09T22:40:00+00:00',
          },
          'skipped': false,
        };

        // Act
        final stopInfo = StopInfo.fromJson(json);

        // Assert
        expect(stopInfo.isOnTime, isTrue);
      });

      test('returns true when actual time equals scheduled time', () {
        // Arrange
        final json = {
          'location': {
            'detailed_name': 'Test Stop',
            'region_name': 'Test Region',
            'lat': 55.0,
            'lon': -3.0,
          },
          'arrival': {
            'scheduled': '2025-03-09T22:42:00+00:00',
            'actual': '2025-03-09T22:42:00+00:00',
          },
          'skipped': false,
        };

        // Act
        final stopInfo = StopInfo.fromJson(json);

        // Assert
        expect(stopInfo.isOnTime, isTrue);
      });

      test('returns false when actual time is after scheduled time', () {
        // Arrange
        final json = {
          'location': {
            'detailed_name': 'Test Stop',
            'region_name': 'Test Region',
            'lat': 55.0,
            'lon': -3.0,
          },
          'arrival': {
            'scheduled': '2025-03-09T22:42:00+00:00',
            'actual': '2025-03-09T22:44:00+00:00',
          },
          'skipped': false,
        };

        // Act
        final stopInfo = StopInfo.fromJson(json);

        // Assert
        expect(stopInfo.isOnTime, isFalse);
      });
    });

    test('props contains all properties', () {
      // Arrange
      final stopInfo = StopInfo(
        detailedName: 'Test Stop',
        regionName: 'Test Region',
        lat: 55,
        lon: -3,
        skipped: false,
        scheduledTime: DateTime.now(),
        stopStatus: StopStatus.upcoming,
        isOnTime: true,
      );

      // Assert
      expect(
        stopInfo.props,
        equals([
          stopInfo.detailedName,
          stopInfo.regionName,
          stopInfo.lat,
          stopInfo.lon,
          stopInfo.skipped,
          stopInfo.scheduledTime,
          stopInfo.actualTime,
          stopInfo.estimatedTime,
          stopInfo.googlePlaceId,
          stopInfo.stopStatus,
          stopInfo.isOnTime,
        ]),
      );
    });
  });
}
