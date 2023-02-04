import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';
import 'package:quiz_maker/data/models/type_definitions.dart';
import 'package:quiz_maker/ui/screens/auth.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/utilities/show_snackbar.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key, required this.changeAuthAction})
      : super(key: key);

  final ChangeAuthAction changeAuthAction;

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _formKey = GlobalKey<FormState>();

  var isSigningIn = false;

  final credentials = {'email': '', 'password': ''};

  var isPasswordVisible = false;

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
            context.goNamed(RoutePaths.root);
          } else {
            widget.changeAuthAction(AuthActions.verifyEmail);
          }
        }
      }).catchError((onError) {
        setState(() {
          isSigningIn = false;
          AppSnackBar.showSnackBar(
              context: context,
              message: onError.toString().split(']')[1],
              isError: true);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16, top: 64),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              children: [
                Text(
                  'Don\'t have an account?',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                TextButton(
                    onPressed: () =>
                        widget.changeAuthAction(AuthActions.register),
                    child: const Text('Register'))
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
                credentials['email'] = text;
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
                  child: FilledButton.tonal(
                      onPressed: isSigningIn
                          ? null
                          : () => widget
                              .changeAuthAction(AuthActions.forgotPassword),
                      child: const Text('Forgot Password?')),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
