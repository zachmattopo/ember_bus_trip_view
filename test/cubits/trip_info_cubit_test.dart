import 'package:dio/dio.dart';
import 'package:ember_bus_trip_view/cubits/trip_info_cubit/trip_info_cubit.dart';
import 'package:ember_bus_trip_view/cubits/trip_info_cubit/trip_info_state.dart';
import 'package:ember_bus_trip_view/models/api_response.dart';
import 'package:ember_bus_trip_view/services/repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock/mock_test_data.dart';

class MockRepository extends Mock implements Repository {}

void main() {
  late TripInfoCubit cubit;
  late MockRepository mockRepository;
  const mockTripId = '123';

  setUp(() {
    mockRepository = MockRepository();
    cubit = TripInfoCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state is TripInfoInitial', () {
    expect(cubit.state, isA<TripInfoInitial>());
  });

  group('fetchTripInfo', () {
    final mockResponse = ApiResponse(success: true, data: MockTestData.mockTripInfoJson);

    test('emits [Loading, Success] when fetch succeeds', () async {
      // Arrange
      when(() => mockRepository.fetchTripInfo(mockTripId)).thenAnswer((_) async => mockResponse);

      // Assert
      expect(
        cubit.stream,
        emitsInOrder([
          isA<TripInfoLoading>(),
          isA<TripInfoSuccess>().having(
            (state) => state.tripInfo.plateNumber,
            'plate number',
            'SG24 UHB',
          ),
        ]),
      );

      // Act
      await cubit.fetchTripInfo(mockTripId);

      // Verify
      verify(() => mockRepository.fetchTripInfo(mockTripId)).called(1);
    });

    test('emits [Loading, Failure] when fetch fails', () async {
      // Arrange
      when(() => mockRepository.fetchTripInfo(mockTripId)).thenAnswer(
        (_) async =>
            ApiResponse(success: false, error: DioException(requestOptions: RequestOptions())),
      );

      // Assert
      expect(cubit.stream, emitsInOrder([isA<TripInfoLoading>(), isA<TripInfoFailure>()]));

      // Act
      await cubit.fetchTripInfo(mockTripId);

      // Verify
      verify(() => mockRepository.fetchTripInfo(mockTripId)).called(1);
    });

    test('emits [Loading, Failure] when DioException occurs', () async {
      // Arrange
      when(
        () => mockRepository.fetchTripInfo(mockTripId),
      ).thenThrow(DioException(requestOptions: RequestOptions()));

      // Assert
      expect(cubit.stream, emitsInOrder([isA<TripInfoLoading>(), isA<TripInfoFailure>()]));

      // Act
      await cubit.fetchTripInfo(mockTripId);
    });
  });
}
