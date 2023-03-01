import 'package:flutter/material.dart';
import 'package:quiz_maker/ui/widgets/dark_mode_widget.dart';
import 'package:quiz_maker/ui/widgets/delete_account.dart';
import 'package:quiz_maker/ui/widgets/logout.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const DarkModeWidget(),
              ],
            ),
          ),
        ),
        const LogoutWidget(),
        const Divider(),
        const DeleteAccount(),
      ],
    );
  }
}
