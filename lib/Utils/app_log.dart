import 'dart:developer';

class AppLog {
  AppLog._();
  static void e(String message, Object data) {
    log("$message: $data");
  }

  static void i(Object message) {
    log("$message");
  }
}
