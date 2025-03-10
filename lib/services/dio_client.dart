import 'package:dio/dio.dart';
import 'package:ember_bus_trip_view/models/api_response.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  Dio dioClient = Dio();

  String get baseUrl => 'https://api.ember.to';

  DioClient() {
    // Set Dio configs
    final BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {'Accept': 'application/json'},
    );

    dioClient = Dio(options);

    dioClient.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (kDebugMode) {
            debugPrint(options.toString());
          }
          return handler.next(options); // continue
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(response.toString());
          }
          return handler.next(response); // continue
        },
        onError: (DioException error, handler) {
          if (kDebugMode) {
            debugPrint(error.toString());
          }
          return handler.next(error); // continue
        },
      ),
    );
  }

  Future<ApiResponse> fetchQuotes(String startOfDayIso8601, String endOfDayIso8601) async {
    final String url =
        '/v1/quotes/?origin=13&destination=42&departure_date_from=$startOfDayIso8601&departure_date_to=$endOfDayIso8601';

    try {
      final Response response = await dioClient.get(url);

      return ApiResponse(success: true, data: response.data);
    } on DioException catch (error) {
      return ApiResponse(success: false, error: error, stackTrace: StackTrace.current);
    }
  }

  Future<ApiResponse> fetchTripInfo(String id) async {
    final String url = '/v1/trips/$id';

    try {
      final Response response = await dioClient.get(url);

      return ApiResponse(success: true, data: response.data);
    } on DioException catch (error) {
      return ApiResponse(success: false, error: error, stackTrace: StackTrace.current);
    }
  }
}
