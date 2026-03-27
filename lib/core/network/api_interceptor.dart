import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../utils/logger.dart';

class ApiInterceptor extends Interceptor {
  ApiInterceptor({
    required SecureStorage secureStorage,
    required String baseUrl,
    required void Function() onUnauthenticated,
  })  : _secureStorage = secureStorage,
        _baseUrl = baseUrl,
        _onUnauthenticated = onUnauthenticated;

  final SecureStorage _secureStorage;
  final String _baseUrl;
  final void Function() _onUnauthenticated;
  bool _isRefreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _secureStorage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isRefreshEndpoint =
        err.requestOptions.path.contains('/auth/refresh');

    if (isUnauthorized && !_isRefreshing && !isRefreshEndpoint) {
      _isRefreshing = true;

      try {
        final refreshToken = await _secureStorage.getRefreshToken();
        if (refreshToken == null) {
          _isRefreshing = false;
          await _secureStorage.clearAll();
          _onUnauthenticated();
          return handler.next(err);
        }

        final refreshDio = Dio(
          BaseOptions(
            baseUrl: _baseUrl,
            connectTimeout: const Duration(seconds: 15),
          ),
        );

        final refreshResponse = await refreshDio.post(
          '/api/v1/auth/refresh',
          data: {'refresh_token': refreshToken},
        );

        final newAccessToken =
            refreshResponse.data['data']?['access_token'] as String?;
        final newRefreshToken =
            refreshResponse.data['data']?['refresh_token'] as String?;

        if (newAccessToken != null) {
          await _secureStorage.saveAccessToken(newAccessToken);
          if (newRefreshToken != null) {
            await _secureStorage.saveRefreshToken(newRefreshToken);
          }

          final retryOptions = err.requestOptions;
          retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final retryResponse = await refreshDio.fetch(retryOptions);
          _isRefreshing = false;
          return handler.resolve(retryResponse);
        }
      } catch (e) {
        Logger.instance
            .e('Token refresh failed', error: e, tag: 'ApiInterceptor');
      }

      _isRefreshing = false;
      await _secureStorage.clearAll();
      _onUnauthenticated();
    }

    handler.next(err);
  }
}
