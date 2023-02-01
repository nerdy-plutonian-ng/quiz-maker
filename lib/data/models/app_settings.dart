// To parse this JSON data, do
//
//     final appSettings = appSettingsFromJson(jsonString);

import 'dart:convert';

class AppSettingsModel {
  AppSettingsModel({
    required this.isDarkModeOn,
  });

  final bool isDarkModeOn;

  factory AppSettingsModel.fromJson(Map<String, Object?> json) =>
      AppSettingsModel(
        isDarkModeOn: json["isDarkModeOn"] as int == 1,
      );

  Map<String, Object?> toJson() => {
        "isDarkModeOn": isDarkModeOn ? 1 : 0,
      };

  static AppSettingsModel appSettingsFromJson(String str) =>
      AppSettingsModel.fromJson(json.decode(str));

  static String appSettingsToJson(AppSettingsModel data) =>
      json.encode(data.toJson());
}
