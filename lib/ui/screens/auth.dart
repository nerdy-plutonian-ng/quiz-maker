import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker/ui/widgets/all_set_widget.dart';
import 'package:quiz_maker/ui/widgets/control_box.dart';
import 'package:quiz_maker/ui/widgets/forgot_password_widget.dart';
import 'package:quiz_maker/ui/widgets/register_widget.dart';
import 'package:quiz_maker/ui/widgets/sign_in_widget.dart';
import 'package:quiz_maker/ui/widgets/verify_email_widget.dart';

enum AuthActions { register, signIn, forgotPassword, verifyEmail, allSet }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late AuthActions? currentAction;
  User? user;

  changeAuthAction(AuthActions authAction) {
    setState(() {
      currentAction = authAction;
    });
  }

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
    print('user email is verified ${user?.emailVerified}');
    if (user != null && !user!.emailVerified) {
      currentAction = AuthActions.verifyEmail;
    } else {
      currentAction = AuthActions.signIn;
    }
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
                  currentAction == AuthActions.register
                      ? 'Enter your email and password to create a new account'
                      : currentAction == AuthActions.signIn
                          ? 'Enter your credentials to sign in'
                          : currentAction == AuthActions.verifyEmail
                              ? 'You have an account but your email is not verified. Check your mail.'
                              : currentAction == AuthActions.forgotPassword
                                  ? 'Enter your email, we will send a reset link to it.'
                                  : 'You have successfully signed in.',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              Expanded(
                  child: ListView(
                children: [
                  if (currentAction == AuthActions.register)
                    RegisterWidget(changeAuthAction: changeAuthAction),
                  if (currentAction == AuthActions.signIn)
                    SignInWidget(changeAuthAction: changeAuthAction),
                  if (currentAction == AuthActions.verifyEmail)
                    VerifyEmailWidget(
                      changeAuthAction: changeAuthAction,
                    ),
                  if (currentAction == AuthActions.forgotPassword)
                    ForgotPasswordWidget(
                      changeAuthAction: changeAuthAction,
                    ),
                  if (currentAction == AuthActions.allSet) const AllSetWidget(),
                ],
              ))
            ],
          ),
        ),
      ),
    ));
  }
}
