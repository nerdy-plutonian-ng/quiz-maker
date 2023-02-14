import '../models/app_settings.dart';

abstract class AppSettings {
  Future<AppSettingsModel?> getAppSettings();

  Future<bool> setAppSettings(AppSettingsModel appSettings);

  Future<bool> clear();
}
