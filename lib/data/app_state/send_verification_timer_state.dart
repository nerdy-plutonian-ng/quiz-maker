import 'package:flutter/foundation.dart';
import 'package:quiz_maker/data/persistence/resend_verification_timer.dart';

class SendVerificationTimerState with ChangeNotifier {
  late DateTime nextTime;

  getNextTime() async {
    final nextTimes = await ResendVerificationTimer.getNextTime();
    print(nextTimes);
    nextTime = DateTime.parse(nextTimes['nextTime'] as String);
    notifyListeners();
  }

  Future<Map<String, Object>?> setNextTime() async {
    final nextTime = await _calculateNextTimes();
    if (await ResendVerificationTimer.saveNextTime(nextTime)) {
      this.nextTime = DateTime.parse(nextTime['nextTime'] as String);
      notifyListeners();
      return nextTime;
    }
    return null;
  }

  Future<Map<String, Object>> _calculateNextTimes() async {
    final currentTimes = await ResendVerificationTimer.getNextTime();
    var retries = currentTimes['retries'] as int;
    final nextTime = currentTimes['nextTime'] as String;
    if (DateTime.now().difference(DateTime.parse(nextTime)).inHours >= 24) {
      return {
        'retries': 0,
        'nextTime': DateTime.now().toIso8601String(),
      };
    }
    return {
      'retries': ++retries,
      'nextTime':
          DateTime.now().add(Duration(minutes: 5 * retries)).toIso8601String(),
    };
  }
}
