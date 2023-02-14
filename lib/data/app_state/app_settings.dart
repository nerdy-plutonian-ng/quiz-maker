import 'package:flutter/foundation.dart';
import 'package:quiz_maker/data/models/app_settings.dart';

class AppSettingsState with ChangeNotifier {
  late AppSettingsModel _appSettings;

  AppSettingsModel get appSettings => _appSettings;

  setAppSettings(AppSettingsModel appSettings, {bool shouldNotify = true}) {
    _appSettings = appSettings;
    if (shouldNotify) {
      notifyListeners();
    }
  }
}
