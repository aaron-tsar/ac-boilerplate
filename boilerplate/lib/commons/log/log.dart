import 'package:logger/logger.dart';

class DLog {
  static final Logger _logger = Logger(
      printer: PrettyPrinter(
          lineLength: 99, methodCount: 0));

  static void info(dynamic message) {
    _logger.i(message);
  }

  static void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message,time:null,error:error,stackTrace: stackTrace);
  }
}
