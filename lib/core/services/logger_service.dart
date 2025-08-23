import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

class Logger {
  static const String _tag = '[Chanzel]';
  
  static void debug(String message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('$_tag [DEBUG] $message');
      if (error != null) {
        debugPrint('$_tag [DEBUG] Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('$_tag [DEBUG] StackTrace: $stackTrace');
      }
    }
  }

  static void info(String message) {
    if (kDebugMode) {
      debugPrint('$_tag [INFO] $message');
    }
  }

  static void warning(String message, {dynamic error}) {
    if (kDebugMode) {
      debugPrint('$_tag [WARNING] $message');
      if (error != null) {
        debugPrint('$_tag [WARNING] Error: $error');
      }
    }
  }

  static void error(String message, {dynamic error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('$_tag [ERROR] $message');
      if (error != null) {
        debugPrint('$_tag [ERROR] Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('$_tag [ERROR] StackTrace: $stackTrace');
      }
    }
  }

  static void critical(String message, {dynamic error, StackTrace? stackTrace}) {
    // Always log critical errors, even in release mode
    debugPrint('$_tag [CRITICAL] $message');
    if (error != null) {
      debugPrint('$_tag [CRITICAL] Error: $error');
    }
    if (stackTrace != null) {
      debugPrint('$_tag [CRITICAL] StackTrace: $stackTrace');
    }
  }
}
