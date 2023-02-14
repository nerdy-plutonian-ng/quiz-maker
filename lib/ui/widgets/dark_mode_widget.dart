import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/app_settings.dart';
import 'package:quiz_maker/data/persistence/app_settings_prefs_saver.dart';

import '../../data/models/app_settings.dart';

class DarkModeWidget extends StatelessWidget {
  const DarkModeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsState>(
      builder: (_, settings, __) {
        return SwitchListTile(
            value: settings.appSettings.isDarkModeOn,
            onChanged: (isDarkModeOn) {
              final newAppSettings =
                  AppSettingsModel(isDarkModeOn: isDarkModeOn);
              AppSettingsPrefsSaver()
                  .setAppSettings(newAppSettings)
                  .then((result) {
                if (result) {
                  settings.setAppSettings(newAppSettings);
                }
              });
            },
            title: const Text('Is dark mode on?'));
      },
    );
  }
}
