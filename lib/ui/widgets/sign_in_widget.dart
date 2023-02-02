import 'package:flutter/material.dart';
import 'package:quiz_maker/data/models/type_definitions.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';

class SignInWidget extends StatefulWidget {
  const SignInWidget({Key? key, required this.changeAuthAction})
      : super(key: key);

  final ChangeAuthAction changeAuthAction;

  @override
  State<SignInWidget> createState() => _SignInWidgetState();
}

class _SignInWidgetState extends State<SignInWidget> {
  final _formKey = GlobalKey<FormState>();

  signIn() {
    if (_formKey.currentState!.validate()) {}
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
                    onPressed: () => widget.changeAuthAction(true),
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
              validator: (text) {
                if (text == null || text.isEmpty) {
                  return 'Required';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
            16.vSpace(),
            FilledButton(onPressed: signIn, child: const Text('Sign In'))
          ],
        ),
      ),
    );
  }
}
