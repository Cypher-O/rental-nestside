import 'package:dio/dio.dart';
import '../utils/logger.dart';

class LoggingInterceptor extends Interceptor {
  LoggingInterceptor(this._logger);

  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d(
      '→ ${options.method} ${options.path}\n'
      'Headers: ${options.headers}\n'
      'Data: ${options.data}',
      tag: 'HTTP',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.d(
      '← ${response.statusCode} ${response.requestOptions.path}\n'
      'Data: ${response.data}',
      tag: 'HTTP',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '✗ ${err.response?.statusCode ?? 'NO_STATUS'} ${err.requestOptions.path}\n'
      'Error: ${err.message}\n'
      'Response: ${err.response?.data}',
      error: err,
      tag: 'HTTP',
    );
    handler.next(err);
  }
}
