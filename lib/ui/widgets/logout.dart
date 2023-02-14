import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/app_settings.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';
import 'package:quiz_maker/data/models/app_settings.dart';
import 'package:quiz_maker/data/persistence/app_settings_prefs_saver.dart';

class LogoutWidget extends StatelessWidget {
  const LogoutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () {
          FirebaseAuth.instance.signOut().then((value) {
            AppSettingsPrefsSaver().clear().then((_) {
              Provider.of<AppSettingsState>(context, listen: false)
                  .setAppSettings(AppSettingsModel(isDarkModeOn: false));
              context.pushReplacementNamed(RoutePaths.root);
            }).catchError((error) {
              if (kDebugMode) {
                print(error);
              }
            });
          });
        },
        // title: const Text('Sign out'),
        title: Text(FirebaseAuth.instance.currentUser?.displayName ?? 'N/A'),
        subtitle: Text(FirebaseAuth.instance.currentUser?.email ?? 'N/A'),
        trailing: const Icon(Icons.logout),
      ),
    );
  }
}
