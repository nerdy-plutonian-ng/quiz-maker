import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/models/app_settings.dart';
import 'package:quiz_maker/data/persistence/app_settings_prefs_saver.dart';
import 'package:quiz_maker/ui/app_theme/color_schemes.g.dart';
import 'package:quiz_maker/ui/utilities/router_config.dart';

import 'data/app_state/app_settings.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final appSettings = await AppSettingsPrefsSaver().getAppSettings();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AppSettingsState()),
    ],
    child: QuizMaker(
      appSettings: appSettings,
    ),
  ));
}

class QuizMaker extends StatelessWidget {
  const QuizMaker({Key? key, this.appSettings}) : super(key: key);

  final AppSettingsModel? appSettings;

  @override
  Widget build(BuildContext context) {
    Provider.of<AppSettingsState>(context, listen: false).setAppSettings(
        appSettings ?? AppSettingsModel(isDarkModeOn: false),
        shouldNotify: false);
    return MaterialApp.router(
      title: 'QuizMaker',
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'Quicksand',
          colorScheme: Provider.of<AppSettingsState>(
            context,
          ).appSettings.isDarkModeOn
              ? darkColorScheme
              : lightColorScheme),
      routerConfig: routerConfig,
    );
  }
}
