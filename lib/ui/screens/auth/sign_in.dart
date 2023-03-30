import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/utilities/messager.dart';

import '../../../data/constants/route_paths.dart';
import '../../widgets/control_box.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  var isSigningIn = false;

  final credentials = {'email': '', 'password': ''};

  var isPasswordVisible = true;

  signIn() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSigningIn = true;
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: credentials['email']!, password: credentials['password']!)
          .then((userCredential) {
        final user = userCredential.user;
        if (user != null) {
          if (user.emailVerified) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get()
                .then((doc) {
              if (!doc.exists) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .set({
                  'userId': FirebaseAuth.instance.currentUser!.uid,
                  'email': FirebaseAuth.instance.currentUser!.email,
                  'username': FirebaseAuth.instance.currentUser!.displayName,
                  'noQuizzesPlayed': 0,
                  'noQuizzesWon': 0,
                  'noSoloQuizzesPlayed': 0,
                  'noPointsAccumulated': 0,
                  'popularityPoints': 0,
                  'quizzes': <Map<String, String>>[],
                }).then((value) {
                  context.goNamed(RoutePaths.root);
                });
              } else {
                context.goNamed(RoutePaths.root);
              }
            });
          } else {
            context.goNamed(RoutePaths.sendEmailVerificationLink);
          }
        }
      }).catchError((onError) {
        setState(() {
          isSigningIn = false;
          Messager.showSnackBar(
              context: context,
              message: onError.toString().split(']')[1],
              isError: true);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ControlBox(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  Row(
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      TextButton(
                          onPressed: () {
                            context.goNamed(RoutePaths.signUp);
                          },
                          child: const Text('Sign Up'))
                    ],
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      suffixIcon: Icon(Icons.alternate_email),
                    ),
                    onChanged: (text) {
                      credentials['email'] = text.toLowerCase().trim();
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          )),
                    ),
                    onChanged: (text) {
                      credentials['password'] = text;
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  if (isSigningIn) const LinearProgressIndicator(),
                  16.vSpace(),
                  Row(
                    children: [
                      FilledButton(
                          onPressed: isSigningIn ? null : signIn,
                          child: const Text('Sign In')),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: OutlinedButton(
                            onPressed: isSigningIn
                                ? null
                                : () {
                                    context.goNamed(RoutePaths.forgotPassword);
                                  },
                            child: const Text('Forgot Password?')),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
