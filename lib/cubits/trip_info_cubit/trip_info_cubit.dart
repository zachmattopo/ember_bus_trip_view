import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/api_response.dart';
import '../../models/trip_info.dart';
import '../../services/repository.dart';
import 'trip_info_state.dart';

class TripInfoCubit extends Cubit<TripInfoState> {
  TripInfoCubit({required Repository repository})
    : _repository = repository,
      super(const TripInfoInitial());

  final Repository _repository;

  Future<void> fetchTripInfo(String tripId) async {
    try {
      emit(const TripInfoLoading());

      final ApiResponse response = await _repository.fetchTripInfo(tripId);

      if (response.success) {
        final tripInfo = TripInfo.fromJson(response.data, tripId);
        emit(TripInfoSuccess(tripInfo: tripInfo));
      } else {
        emit(TripInfoFailure(errorMessage: response.errorData['message']));
      }
    } on DioException catch (e, _) {
      emit(TripInfoFailure(errorMessage: e.toString()));
      // Log the error and stackTrace in Crashlytics etc.
    }
  }
}
