import 'package:flutter/foundation.dart';

void logDebug(String message) {
  if (kDebugMode) {
    print(message);
  }
}

void logError(Exception e) {
  if (kDebugMode) {
    print("Error: ${e.toString()}");
  }
}
