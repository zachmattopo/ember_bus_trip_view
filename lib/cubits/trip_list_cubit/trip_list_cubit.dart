import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/api_response.dart';
import '../../models/trip.dart';
import '../../services/repository.dart';
import 'trip_list_state.dart';

class TripListCubit extends Cubit<TripListState> {
  TripListCubit({required Repository repository})
    : _repository = repository,
      super(const TripListInitial());

  final Repository _repository;

  Future<void> fetchTripList() async {
    try {
      emit(const TripListLoading());

      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final ApiResponse response = await _repository.fetchQuotes(
        startOfDayIso8601: startOfDay.toUtc().toIso8601String(),
        endOfDayIso8601: endOfDay.toUtc().toIso8601String(),
      );

      if (response.success) {
        final List<dynamic> quotesJson = response.data['quotes'] as List;
        final List<Trip> trips = quotesJson.map((json) => Trip.fromJson(json)).toList();
        emit(TripListSuccess(trips: trips));
      } else {
        emit(TripListFailure(errorMessage: response.errorData['message']));
      }
    } on DioException catch (e, _) {
      emit(TripListFailure(errorMessage: e.toString()));
      // Log the error and stackTrace in Crashlytics etc.
    }
  }
}
