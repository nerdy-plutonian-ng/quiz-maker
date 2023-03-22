import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ResendVerificationTimer {
  static Future<bool> saveNextTime(Map<String, Object> nextTime) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('nextTime', jsonEncode(nextTime));
  }

  static Future<Map<String, Object>> getNextTime() async {
    final prefs = await SharedPreferences.getInstance();
    final nextTimeString = prefs.getString('nextTime');
    if (nextTimeString == null) {
      return {
        'retries': 0,
        'nextTime': DateTime.now().toIso8601String(),
      };
    }
    final res = jsonDecode(nextTimeString);
    return <String, Object>{
      'retries': res['retries'],
      'nextTime': res['nextTime'],
    };
  }
}
