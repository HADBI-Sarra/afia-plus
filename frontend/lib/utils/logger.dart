import 'package:flutter/foundation.dart';

/// Logger utility - only prints in debug mode
/// In release builds, these become no-ops
class AppLogger {
  static void log(String message) {
    if (kDebugMode) {
      debugPrint(message);
    }
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    // Always log errors
    debugPrint('❌ ERROR: $message');
    if (error != null) debugPrint('Details: $error');
    if (stackTrace != null) debugPrint('Stack: $stackTrace');
  }

  static void info(String message) {
    if (kDebugMode) {
      debugPrint('ℹ️ $message');
    }
  }

  static void success(String message) {
    if (kDebugMode) {
      debugPrint('✅ $message');
    }
  }

  static void warning(String message) {
    if (kDebugMode) {
      debugPrint('⚠️ $message');
    }
  }
}
