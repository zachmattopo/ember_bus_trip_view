import 'package:dio/dio.dart';
import 'package:ember_bus_trip_view/cubits/trip_list_cubit/trip_list_cubit.dart';
import 'package:ember_bus_trip_view/cubits/trip_list_cubit/trip_list_state.dart';
import 'package:ember_bus_trip_view/models/api_response.dart';
import 'package:ember_bus_trip_view/models/trip.dart';
import 'package:ember_bus_trip_view/services/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock/mock_test_data.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late TripListCubit cubit;
  late MockRepository mockRepository;

  setUp(() {
    mockRepository = MockRepository();
    cubit = TripListCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is TripListInitial', () {
    expect(cubit.state, isA<TripListInitial>());
  });

  group('fetchTripList', () {
    final mockTrips = [
      Trip(
        tripUid: 'EXeaxiMXZ7oeP4CWsPKAno',
        scheduledDeparture: DateTime(2025, 3, 9, 00, 40),
        numberPlate: 'SG24 UJW',
        tripStatus: TripStatus.past,
      ),
    ];

    final mockResponse = ApiResponse(success: true, data: MockTestData.mockTripJson);

    test('emits [Loading, Success] when fetch succeeds', () async {
      // Arrange
      when(
        () => mockRepository.fetchQuotes(
          startOfDayIso8601: any(named: 'startOfDayIso8601'),
          endOfDayIso8601: any(named: 'endOfDayIso8601'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Assert
      expect(
        cubit.stream,
        emitsInOrder([
          isA<TripListLoading>(),
          isA<TripListSuccess>().having(
            (state) => state.trips.first.tripUid,
            'first trip id',
            mockTrips.first.tripUid,
          ),
        ]),
      );

      // Act
      await cubit.fetchTripList();
    });

    test('emits [Loading, Failure] when fetch fails', () async {
      // Arrange
      when(
        () => mockRepository.fetchQuotes(
          startOfDayIso8601: any(named: 'startOfDayIso8601'),
          endOfDayIso8601: any(named: 'endOfDayIso8601'),
        ),
      ).thenAnswer(
        (_) async =>
            ApiResponse(success: false, error: DioException(requestOptions: RequestOptions())),
      );

      // Assert
      expect(cubit.stream, emitsInOrder([isA<TripListLoading>(), isA<TripListFailure>()]));

      // Act
      await cubit.fetchTripList();
    });

    test('emits [Loading, Failure] when DioException occurs', () async {
      // Arrange
      when(
        () => mockRepository.fetchQuotes(
          startOfDayIso8601: any(named: 'startOfDayIso8601'),
          endOfDayIso8601: any(named: 'endOfDayIso8601'),
        ),
      ).thenThrow(DioException(requestOptions: RequestOptions()));

      // Assert
      expect(cubit.stream, emitsInOrder([isA<TripListLoading>(), isA<TripListFailure>()]));

      // Act
      await cubit.fetchTripList();
    });
  });
}
