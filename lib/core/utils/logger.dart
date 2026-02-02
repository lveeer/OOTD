import 'dart:developer' as developer;

class AppLogger {
  static const String _defaultTag = 'OOTD';

  static void debug(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? _defaultTag,
      level: 500, // Level.FINE
    );
  }

  static void info(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? _defaultTag,
      level: 800, // Level.INFO
    );
  }

  static void warning(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? _defaultTag,
      level: 900, // Level.WARNING
    );
  }

  static void error(String message, {Object? error, StackTrace? stackTrace, String? tag}) {
    developer.log(
      message,
      name: tag ?? _defaultTag,
      level: 1000, // Level.SEVERE
      error: error,
      stackTrace: stackTrace,
    );
  }
}