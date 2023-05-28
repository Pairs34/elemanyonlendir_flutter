import 'package:seq_logger/seq_logger.dart';

class Globals{
  static String? token = "";

  static sendMessageToSeq(String msg, LogLevel lvl, Map<String, dynamic> data)
  {
    SeqLogger.addLogToDb(message: msg,data: {
      "AppName": "CleanerMy"
    });
    SeqLogger.sendLogs();
  }
}