import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/create_quiz_state.dart';
import 'package:quiz_maker/data/app_state/quiz_state.dart';
import 'package:quiz_maker/data/app_state/send_verification_timer_state.dart';
import 'package:quiz_maker/data/app_state/single_quiz_state.dart';
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
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  final appSettings = await AppSettingsPrefsSaver().getAppSettings();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SendVerificationTimerState()),
      ChangeNotifierProvider(create: (_) => AppSettingsState()),
      ChangeNotifierProvider(create: (_) => QuizState()),
      ChangeNotifierProvider(create: (_) => CreateQuizState()),
      ChangeNotifierProvider(create: (_) => SingleQuizState()),
    ],
    child: QuizMaker(
      appSettings: appSettings,
    ),
  ));
}

class QuizMaker extends StatefulWidget {
  const QuizMaker({Key? key, this.appSettings}) : super(key: key);

  final AppSettingsModel? appSettings;

  @override
  State<QuizMaker> createState() => _QuizMakerState();
}

class _QuizMakerState extends State<QuizMaker> {
  @override
  void initState() {
    super.initState();
    Provider.of<AppSettingsState>(context, listen: false).setAppSettings(
        widget.appSettings ?? AppSettingsModel(),
        shouldNotify: false);
    Provider.of<SendVerificationTimerState>(context, listen: false)
        .getNextTime();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
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
