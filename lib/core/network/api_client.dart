import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'api_interceptor.dart';
import 'logging_interceptor.dart';
import 'result.dart';
import '../constants/api_constants.dart';
import '../storage/secure_storage.dart';
import '../utils/logger.dart';

class ApiClient {
  ApiClient({
    required String baseUrl,
    required SecureStorage secureStorage,
    required Logger logger,
    required void Function() onUnauthenticated,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      ApiInterceptor(
        secureStorage: secureStorage,
        baseUrl: baseUrl,
        onUnauthenticated: onUnauthenticated,
      ),
      LoggingInterceptor(logger),
    ]);
  }

  late final Dio _dio;

  /// Retries [fn] up to [maxAttempts] times on transient connection errors
  /// (closed connections, TLS handshake failures).
  Future<Result<T>> _withRetry<T>(
    Future<Result<T>> Function() fn, {
    int maxAttempts = 3,
  }) async {
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      final result = await fn();
      if (result.isSuccess) return result;
      // Only retry on connection-level errors, not server errors
      final isRetryable = result.errorOrEmpty.contains('Connection closed') ||
          result.errorOrEmpty.contains('HandshakeException') ||
          result.errorOrEmpty.contains('TLS') ||
          result.errorOrEmpty.contains('SocketException');
      if (!isRetryable || attempt == maxAttempts) return result;
      await Future.delayed(Duration(milliseconds: 300 * attempt));
    }
    return fn();
  }

  Future<Result<T>> get<T>({
    required String endpoint,
    required T Function(dynamic) parser,
    Map<String, dynamic>? queryParams,
  }) =>
      _withRetry(() async {
        try {
          final response = await _dio.get(
            endpoint,
            queryParameters: queryParams,
          );
          return Result.success(parser(response.data['data'] ?? response.data));
        } on DioException catch (e) {
          return Result.failure(_handleDioError(e));
        } catch (e) {
          return Result.failure(e.toString());
        }
      });

  Future<Result<T>> post<T>({
    required String endpoint,
    required T Function(dynamic) parser,
    Map<String, dynamic>? data,
  }) =>
      _withRetry(() async {
        try {
          final response = await _dio.post(endpoint, data: data);
          return Result.success(parser(response.data['data'] ?? response.data));
        } on DioException catch (e) {
          return Result.failure(_handleDioError(e));
        } catch (e) {
          return Result.failure(e.toString());
        }
      });

  Future<Result<T>> put<T>({
    required String endpoint,
    required T Function(dynamic) parser,
    Map<String, dynamic>? data,
  }) =>
      _withRetry(() async {
        try {
          final response = await _dio.put(endpoint, data: data);
          return Result.success(parser(response.data['data'] ?? response.data));
        } on DioException catch (e) {
          return Result.failure(_handleDioError(e));
        } catch (e) {
          return Result.failure(e.toString());
        }
      });

  Future<Result<List<String>>> postMultipartFiles({
    required String endpoint,
    required List<XFile> files,
    String fieldName = 'images',
  }) async {
    try {
      final formData = FormData();
      for (final file in files) {
        // Read bytes eagerly — avoids stale temp-path issues on iOS/Android
        final bytes = await file.readAsBytes();
        formData.files.add(MapEntry(
          fieldName,
          MultipartFile.fromBytes(bytes, filename: file.name),
        ));
      }
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(
          // Do NOT set contentType — Dio adds multipart/form-data;boundary=... automatically
          sendTimeout: const Duration(minutes: 2),
          receiveTimeout: const Duration(minutes: 1),
        ),
      );
      final body = response.data is Map
          ? (response.data['data'] ?? response.data)
          : response.data;
      final images = body is Map
          ? List<String>.from((body['images'] as List? ?? []))
          : <String>[];
      return Result.success(images);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> delete({required String endpoint}) async {
    try {
      await _dio.delete(endpoint);
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_handleDioError(e));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Connection timed out. Please check your internet connection.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please try again.';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final responseData = e.response?.data;

        if (responseData is Map) {
          final serverError = responseData['error'] as String? ??
              responseData['message'] as String?;
          if (serverError != null && serverError.isNotEmpty) {
            return serverError;
          }
        }

        switch (statusCode) {
          case 400:
            return 'Bad request. Please check your input.';
          case 401:
            return 'Unauthorized. Please login again.';
          case 403:
            return 'You do not have permission to perform this action.';
          case 404:
            return 'Resource not found.';
          case 409:
            return 'Conflict. Resource already exists.';
          case 422:
            return 'Validation error. Please check your input.';
          case 500:
            return 'Server error. Please try again later.';
          default:
            return 'Request failed with status: $statusCode';
        }
      default:
        final underlying = e.error?.toString() ?? '';
        if (underlying.contains('SSLV3') ||
            underlying.contains('SSL') ||
            underlying.contains('TLS') ||
            underlying.contains('HandshakeException') ||
            underlying.contains('CERTIFICATE') ||
            underlying.contains('tls_record')) {
          return 'Connection error. Please try again.';
        }
        if (underlying.contains('SocketException') ||
            underlying.contains('NetworkException') ||
            underlying.contains('HttpException')) {
          return 'Network error. Please check your connection and try again.';
        }
        if (underlying.isNotEmpty) return underlying;
        return e.message ?? 'An unexpected error occurred.';
    }
  }
}
