import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/utilities/show_snackbar.dart';

import '../../data/models/type_definitions.dart';

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({Key? key, required this.changeAuthAction})
      : super(key: key);

  final ChangeAuthAction changeAuthAction;

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  final _formKey = GlobalKey<FormState>();
  final registerObject = <String, String>{
    'displayName': '',
    'email': '',
    'password': '',
    'confirmPassword': ''
  };
  var isSubmitting = false;

  signIn() {
    if (_formKey.currentState!.validate()) {
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: registerObject['email']!,
              password: registerObject['password']!)
          .then((userCredential) {})
          .catchError((error) {
        AppSnackBar.showSnackBar(
            context: context,
            message: error.toString().split(']')[1],
            isError: true);
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
              'Register',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Row(
              children: [
                Text(
                  'Already have an account?',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                TextButton(
                    onPressed: () => widget.changeAuthAction(false),
                    child: const Text('Sign In'))
              ],
            ),
            TextFormField(
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                suffixIcon: Icon(Icons.person),
              ),
              onChanged: (text) {
                registerObject['displayName'] = text;
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
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email',
                suffixIcon: Icon(Icons.alternate_email),
              ),
              onChanged: (text) {
                registerObject['email'] = text;
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
              textInputAction: TextInputAction.next,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                suffixIcon: Icon(Icons.password),
              ),
              onChanged: (text) {
                registerObject['password'] = text;
              },
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Required';
                }
                if (text.length < 8) {
                  return 'Password must be 8 or more characters';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
                suffixIcon: Icon(Icons.password),
              ),
              onChanged: (text) {
                registerObject['confirmPassword'] = text;
              },
              validator: (text) {
                if (text == null || text != registerObject['password']) {
                  return 'Passwords do not match';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            16.vSpace(),
            if (isSubmitting)
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: LinearProgressIndicator(),
              ),
            FilledButton(
                onPressed: isSubmitting ? null : signIn,
                child: const Text('Register'))
          ],
        ),
      ),
    );
  }
}
