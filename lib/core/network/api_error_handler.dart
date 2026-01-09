import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handleErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timeout. Please check your internet.";
        case DioExceptionType.sendTimeout:
          return "Send timeout. Please try again.";
        case DioExceptionType.receiveTimeout:
          return "Receive timeout. Server is not responding.";
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode != null) {
            return _handleStatusCode(statusCode, error.response?.data);
          }
          return "Unexpected server response.";
        case DioExceptionType.cancel:
          return "Request was cancelled.";
        case DioExceptionType.connectionError:
          return "No internet connection.";
        default:
          return "Something went wrong. Please try again later.";
      }
    }
    return error.toString();
  }

  static String _handleStatusCode(int statusCode, dynamic data) {
    switch (statusCode) {
      case 400:
        return data?['message'] ?? "Invalid request.";
      case 401:
        return "Unauthorized. Please login again.";
      case 403:
        return "Permission denied.";
      case 404:
        return "Resource not found.";
      case 422:
        return data?['message'] ?? "Validation error.";
      case 500:
        return "Internal server error. Please try again later.";
      case 503:
        return "Service unavailable. Server might be down.";
      default:
        return "Server error: $statusCode";
    }
  }
}
