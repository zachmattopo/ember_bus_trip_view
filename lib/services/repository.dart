import 'package:ember_bus_trip_view/models/api_response.dart';
import 'package:ember_bus_trip_view/services/dio_client.dart';

class Repository {
  static final Repository _repository = Repository._internal();

  static Repository get() {
    return _repository;
  }

  Repository._internal();

  final DioClient apiClient = DioClient();

  Future<ApiResponse> fetchQuotes({
    required String startOfDayIso8601,
    required String endOfDayIso8601,
  }) => apiClient.fetchQuotes(startOfDayIso8601, endOfDayIso8601);

  Future<ApiResponse> fetchTripInfo(String id) => apiClient.fetchTripInfo(id);
}
