import 'package:quiz_maker/data/constants/app_strings.dart';
import 'package:quiz_maker/data/models/app_settings.dart';
import 'package:quiz_maker/data/persistence/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettingsPrefsSaver implements AppSettings {
  @override
  Future<AppSettingsModel?> getAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final appSettings = prefs.getString(AppStrings.appSettings);
    if (appSettings != null) {
      return AppSettingsModel.appSettingsFromJson(appSettings);
    }
    return null;
  }

  @override
  Future<bool> setAppSettings(AppSettingsModel appSettings) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(AppStrings.appSettings,
        AppSettingsModel.appSettingsToJson(appSettings));
  }
}
