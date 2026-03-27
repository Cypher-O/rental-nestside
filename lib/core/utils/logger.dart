import 'dart:developer' as developer;

class Logger {
  Logger._();
  static final Logger instance = Logger._();

  bool _isEnabled = true;

  static void init({required bool isEnabled}) {
    instance._isEnabled = isEnabled;
  }

  void d(String message, {String? tag}) {
    if (!_isEnabled) return;
    developer.log(message, name: tag ?? 'DEBUG', level: 500);
  }

  void i(String message, {String? tag}) {
    if (!_isEnabled) return;
    developer.log(message, name: tag ?? 'INFO', level: 800);
  }

  void e(String message,
      {Object? error, StackTrace? stackTrace, String? tag}) {
    if (!_isEnabled) return;
    developer.log(message,
        name: tag ?? 'ERROR',
        level: 1000,
        error: error,
        stackTrace: stackTrace);
  }

  void w(String message, {String? tag}) {
    if (!_isEnabled) return;
    developer.log(message, name: tag ?? 'WARN', level: 900);
  }
}
