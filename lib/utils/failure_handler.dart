import 'package:dio/dio.dart';
import 'dart:io';
import '../domain/failures/failures.dart';
import 'log.dart';

class FailureHandler {
  static void logFailure(Failure failure, {String? context}) {
    final contextPrefix = context != null ? '[$context] ' : '';
    
    if (failure is NetworkFailure) {
      Log.red('${contextPrefix}Network Failure: ${failure.message}');
      if (failure.stackTrace != null) {
        Log.red('${contextPrefix}Stack Trace: ${failure.stackTrace}');
      }
    } else if (failure is DeviceFailure) {
      Log.red('${contextPrefix}Device Failure: ${failure.message}');
      if (failure.stackTrace != null) {
        Log.red('${contextPrefix}Stack Trace: ${failure.stackTrace}');
      }
    } else if (failure is ServerFailure) {
      Log.red('${contextPrefix}Server Failure: ${failure.message}');
      Log.red('${contextPrefix}Status Code: ${failure.statusCode}');
      Log.red('${contextPrefix}Response Body: ${failure.responseBody}');
      if (failure.stackTrace != null) {
        Log.red('${contextPrefix}Stack Trace: ${failure.stackTrace}');
      }
    } else if (failure is UnknownFailure) {
      Log.red('${contextPrefix}Unknown Failure: ${failure.message}');
      if (failure.stackTrace != null) {
        Log.red('${contextPrefix}Stack Trace: ${failure.stackTrace}');
      }
    }
  }

  static Failure categorizeException(dynamic exception, [StackTrace? stackTrace]) {
    if (exception is DioException) {
      return _handleDioException(exception);
    } else if (exception is SocketException) {
      return NetworkFailure.fromSocketException(exception, stackTrace);
    } else if (exception is TypeError) {
      return DeviceFailure.fromTypeError(exception);
    } else {
      return UnknownFailure.fromException(exception, stackTrace);
    }
  }

  static Failure _handleDioException(DioException e) {
    Log.red('DioException: ${e.type} - ${e.message}');
    Log.red('Status Code: ${e.response?.statusCode}');
    Log.red('Response Data: ${e.response?.data}');
    
    // Handle different DioException types
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return NetworkFailure.fromDioException(e);
    }
    
    // Handle server errors (4xx, 5xx)
    if (e.response != null && e.response!.statusCode! >= 400) {
      return ServerFailure.fromDioException(e);
    }
    
    // Handle other network errors
    return NetworkFailure.fromDioException(e);
  }

  static String getUserFriendlyMessage(Failure failure) {
    if (failure is NetworkFailure) {
      return failure.message;
    } else if (failure is DeviceFailure) {
      return 'Something went wrong on your device. Please try again.';
    } else if (failure is ServerFailure) {
      return failure.message;
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  static bool shouldRetry(Failure failure) {
    // Don't retry device failures (parsing errors, etc.)
    if (failure is DeviceFailure) {
      return false;
    }
    
    // Don't retry server errors that are likely permanent
    if (failure is ServerFailure) {
      final statusCode = failure.statusCode;
      return statusCode != null && 
             statusCode != 400 && 
             statusCode != 401 && 
             statusCode != 403 && 
             statusCode != 404;
    }
    
    // Retry network failures and unknown failures
    return true;
  }
} 