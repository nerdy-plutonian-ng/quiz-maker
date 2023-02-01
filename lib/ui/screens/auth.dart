import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as email_auth;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_, snapshot) {
          return Scaffold(
            body: SafeArea(
              top: true,
              child: SizedBox.expand(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(children: [
                    Text(
                      'Quiz Maker',
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    if (snapshot.data != null)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('You are logged in now, you go to home'),
                          ElevatedButton(
                            onPressed: () {
                              context.go(RoutePaths.root);
                            },
                            child: const Text('Go To Home'),
                          ),
                        ],
                      ),
                    if (snapshot.data == null)
                      Expanded(
                        child: email_auth.SignInScreen(
                          providers: [
                            email_auth.EmailAuthProvider(),
                          ],
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
