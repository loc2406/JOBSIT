import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2, // số dòng stack trace
        errorMethodCount: 5, // số dòng khi log error
        lineLength: 80, // độ dài tối đa 1 dòng log
        colors: true, // bật màu
        printEmojis: true, // bật emoji
        dateTimeFormat: DateTimeFormat.onlyTime),
  );

  static void d(dynamic message) {
    if (!kReleaseMode) _logger.d(message);
  }

  static void i(dynamic message){
    if (!kReleaseMode) _logger.i(message);
  }

  static void w(dynamic message){
    if (!kReleaseMode) _logger.w(message);
  }
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (!kReleaseMode) _logger.e(message, error: error, stackTrace: stackTrace);
  }
}
