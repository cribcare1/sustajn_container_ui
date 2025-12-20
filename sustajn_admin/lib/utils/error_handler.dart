import 'package:dio/dio.dart';

class DioErrorHandler {
  static String handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout";

      case DioExceptionType.sendTimeout:
        return "Request timeout";

      case DioExceptionType.receiveTimeout:
        return "Response timeout";

      case DioExceptionType.badResponse:
        final response = error.response;
        final statusCode = response?.statusCode;

        if (statusCode == 401) {
          return "Unauthorized access";
        } else if (statusCode == 404) {
          return "Data not found";
        } else if (statusCode == 500) {
          return "Server error";
        } else {
          return response?.data is Map
              ? response?.data['message'] ?? "Something went wrong"
              : "Something went wrong";
        }

      case DioExceptionType.cancel:
        return "Request cancelled";

      case DioExceptionType.unknown:
      default:
        return "No internet connection";
    }
  }
}
