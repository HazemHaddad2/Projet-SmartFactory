import 'package:flutter/foundation.dart';

void debugLog(String message) {
  if (kDebugMode) {
    debugPrint('[DEBUG] $message');
  }
}

void errorLog(String message, [dynamic error]) {
  if (kDebugMode) {
    debugPrint('[ERROR] $message');
    if (error != null) {
      debugPrint('[ERROR] $error');
    }
  }
}

void infoLog(String message) {
  if (kDebugMode) {
    debugPrint('[INFO] $message');
  }
}
