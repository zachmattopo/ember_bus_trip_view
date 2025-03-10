import 'package:ember_bus_trip_view/models/trip.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock/mock_test_data.dart';

void main() {
  group('Trip', () {
    test('fromJson creates Trip with correct values', () {
      // Arrange
      final json = MockTestData.mockTripJson['quotes'][0];

      // Act
      final trip = Trip.fromJson(json);

      // Assert
      expect(trip.tripUid, equals('EXeaxiMXZ7oeP4CWsPKAno'));
      expect(
        trip.scheduledDeparture,
        equals(DateTime.parse('2025-03-09T00:40:00+00:00').toLocal()),
      );
      expect(trip.numberPlate, equals('SG24 UJW'));
    });

    group('tripStatus', () {
      test('returns TripStatus.past when both actual departure and arrival exist', () {
        // Arrange
        final json = {
          'legs': [
            {
              'trip_uid': 'test_id',
              'departure': {
                'scheduled': '2025-03-09T00:40:00+00:00',
                'actual': '2025-03-09T00:43:17+00:00',
              },
              'arrival': {
                'scheduled': '2025-03-09T02:21:00+00:00',
                'actual': '2025-03-09T02:23:36+00:00',
              },
              'description': {'number_plate': 'TEST123'},
            },
          ],
        };

        // Act
        final trip = Trip.fromJson(json);

        // Assert
        expect(trip.tripStatus, equals(TripStatus.past));
      });

      test('returns TripStatus.active when only actual departure exists', () {
        // Arrange
        final json = {
          'legs': [
            {
              'trip_uid': 'test_id',
              'departure': {
                'scheduled': '2025-03-09T00:40:00+00:00',
                'actual': '2025-03-09T00:43:17+00:00',
              },
              'arrival': {'scheduled': '2025-03-09T02:21:00+00:00'},
              'description': {'number_plate': 'TEST123'},
            },
          ],
        };

        // Act
        final trip = Trip.fromJson(json);

        // Assert
        expect(trip.tripStatus, equals(TripStatus.active));
      });

      test('returns TripStatus.upcoming when no actual times exist', () {
        // Arrange
        final json = {
          'legs': [
            {
              'trip_uid': 'test_id',
              'departure': {'scheduled': '2025-03-09T00:40:00+00:00'},
              'arrival': {'scheduled': '2025-03-09T02:21:00+00:00'},
              'description': {'number_plate': 'TEST123'},
            },
          ],
        };

        // Act
        final trip = Trip.fromJson(json);

        // Assert
        expect(trip.tripStatus, equals(TripStatus.upcoming));
      });
    });

    test('props contains all properties', () {
      // Arrange
      final trip = Trip(
        tripUid: 'test_id',
        scheduledDeparture: DateTime.now(),
        numberPlate: 'TEST123',
        tripStatus: TripStatus.upcoming,
      );

      // Assert
      expect(
        trip.props,
        equals([trip.tripUid, trip.scheduledDeparture, trip.numberPlate, trip.tripStatus]),
      );
    });
  });
}
