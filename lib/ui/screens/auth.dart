import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as email_auth;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          if (snapshot.data != null && !snapshot.data!.emailVerified) {
            snapshot.data?.sendEmailVerification();
          }
          return Scaffold(
            body: SafeArea(
              top: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox.expand(
                  child: Column(children: [
                    Text(
                      'Quiz Maker',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListTile(
                        leading: const Icon(Icons.info),
                        title: Text(
                          snapshot.data == null
                              ? 'Enter your email and password to sign in to your account'
                              : !snapshot.data!.emailVerified
                                  ? 'You have registered but have not verified your email. Check your inbox.'
                                  : 'You have successfully signed in',
                        ),
                      ),
                    ),
                    Expanded(
                      child: snapshot.data == null
                          ? email_auth.SignInScreen(
                              providers: [
                                email_auth.EmailAuthProvider(),
                              ],
                            )
                          : Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    snapshot.data!.emailVerified
                                        ? 'You are signed in successfully'
                                        : 'Check your inbox, ${snapshot.data!.email!}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  if (snapshot.data!.emailVerified)
                                    FilledButton(
                                        onPressed: () {
                                          context.pushReplacementNamed(
                                              RoutePaths.root);
                                        },
                                        child: const Text('Go To Home')),
                                  if (!snapshot.data!.emailVerified)
                                    FilledButton.tonal(
                                        onPressed: () {
                                          FirebaseAuth.instance.currentUser
                                              ?.sendEmailVerification();
                                        },
                                        child: const Text(
                                            'Resend verification email')),
                                ],
                              ),
                            ),
                    )
                  ]),
                ),
              ),
            ),
          );
        });
  }
}
