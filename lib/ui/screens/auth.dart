import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker/ui/widgets/all_set_widget.dart';
import 'package:quiz_maker/ui/widgets/control_box.dart';
import 'package:quiz_maker/ui/widgets/register_widget.dart';
import 'package:quiz_maker/ui/widgets/sign_in_widget.dart';
import 'package:quiz_maker/ui/widgets/verify_email_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  User? user;
  var isRegistering = false;

  changeAuthAction(bool authAction) {
    print('called : $authAction');
    setState(() {
      isRegistering = authAction;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ControlBox(
          child: Column(
            children: [
              Text(
                'Quiz Maker',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(
                height: 16,
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: Text(
                  user == null && isRegistering
                      ? 'Enter your email and password to create a new account'
                      : user == null && !isRegistering
                          ? 'Enter your credentials to sign in'
                          : !user!.emailVerified
                              ? 'You have an account but your email is not verified'
                              : 'You have successfully signed in.',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Expanded(
                  child: ListView(
                children: [
                  if (user == null && isRegistering)
                    RegisterWidget(changeAuthAction: changeAuthAction),
                  if (user == null && !isRegistering)
                    SignInWidget(changeAuthAction: changeAuthAction),
                  if (user != null && !user!.emailVerified)
                    const VerifyEmailWidget(),
                  if (user != null && user!.emailVerified) const AllSetWidget(),
                ],
              ))
            ],
          ),
        ),
      ),
    ));
  }
}
