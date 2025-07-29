import 'dart:io';
import 'package:dio/dio.dart';

// Base Failure class
abstract class Failure {
  final String message;
  final String? stackTrace;

  const Failure({required this.message, this.stackTrace});

  @override
  String toString() => 'Failure: $message';
}

// Network/Internet Connection Failure
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.stackTrace});

  factory NetworkFailure.fromDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const NetworkFailure(
        message: 'Connection timeout. Please check your internet connection.',
      );
    }
    
    if (e.type == DioExceptionType.connectionError) {
      return const NetworkFailure(
        message: 'No internet connection. Please check your network settings.',
      );
    }
    
    return NetworkFailure(
      message: 'Network error: ${e.message}',
      stackTrace: e.stackTrace.toString(),
    );
  }

  factory NetworkFailure.fromSocketException(SocketException e, [StackTrace? stackTrace]) {
    return NetworkFailure(
      message: 'No internet connection: ${e.message}',
      stackTrace: stackTrace?.toString(),
    );
  }
}

// Device/Client Failure (Parsing errors, wrong object structure, etc.)
class DeviceFailure extends Failure {
  const DeviceFailure({required super.message, super.stackTrace});

  factory DeviceFailure.fromException(dynamic e, [StackTrace? stackTrace]) {
    return DeviceFailure(
      message: 'Device error: ${e.toString()}',
      stackTrace: stackTrace?.toString(),
    );
  }

  factory DeviceFailure.fromJsonParsingError(String jsonString, dynamic error) {
    return DeviceFailure(
      message: 'Failed to parse JSON response: ${error.toString()}',
      stackTrace: error is Error ? error.stackTrace?.toString() : null,
    );
  }

  factory DeviceFailure.fromTypeError(TypeError error) {
    return DeviceFailure(
      message: 'Type error: ${error.toString()}',
      stackTrace: error.stackTrace?.toString(),
    );
  }
}

// Server Failure (4xx, 5xx errors)
class ServerFailure extends Failure {
  final int? statusCode;
  final String? responseBody;

  const ServerFailure({
    required String message, 
    this.statusCode, 
    this.responseBody,
    String? stackTrace,
  }) : super(message: message, stackTrace: stackTrace);

  factory ServerFailure.fromDioException(DioException e) {
    final statusCode = e.response?.statusCode;
    final responseBody = e.response?.data?.toString();
    
    String message;
    switch (statusCode) {
      case 400:
        message = 'Bad request. Please check your input.';
        break;
      case 401:
        message = 'Unauthorized. Please login again.';
        break;
      case 403:
        message = 'Forbidden. You don\'t have permission to access this resource.';
        break;
      case 404:
        message = 'Resource not found.';
        break;
      case 422:
        message = 'Validation error. Please check your input.';
        break;
      case 429:
        message = 'Too many requests. Please try again later.';
        break;
      case 500:
        message = 'Internal server error. Please try again later.';
        break;
      case 502:
        message = 'Bad gateway. Please try again later.';
        break;
      case 503:
        message = 'Service unavailable. Please try again later.';
        break;
      case 504:
        message = 'Gateway timeout. Please try again later.';
        break;
      default:
        message = 'Server error (${statusCode ?? 'unknown'}): ${e.message}';
    }

    return ServerFailure(
      message: message,
      statusCode: statusCode,
      responseBody: responseBody,
      stackTrace: e.stackTrace.toString(),
    );
  }
}

// Unknown/Unexpected Failure
class UnknownFailure extends Failure {
  const UnknownFailure({required super.message, super.stackTrace});

  factory UnknownFailure.fromException(dynamic e, [StackTrace? stackTrace]) {
    return UnknownFailure(
      message: 'Unexpected error: ${e.toString()}',
      stackTrace: stackTrace?.toString(),
    );
  }
} 