import 'package:flutter/foundation.dart';

class LogService {
  static final List<String> _logs = [];
  
  static void log(String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final formatted = '[$timestamp] $message';
    _logs.add(formatted);
    if (kDebugMode) {
      print(formatted);
    }
    if (_logs.length > 100) _logs.removeAt(0);
  }

  static List<String> get logs => List.unmodifiable(_logs);
  
  static void clear() => _logs.clear();
}
