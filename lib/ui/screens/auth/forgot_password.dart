import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/utilities/messager.dart';
import 'package:quiz_maker/ui/widgets/control_box.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var isSubmitting = false;
  var email = '';

  resetPassword() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isSubmitting = true;
      });
      FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((_) {
        setState(() {
          isSubmitting = false;
        });
        context.goNamed(RoutePaths.signIn);
        Messager.showSnackBar(
            context: context,
            message: 'Check your mail for a password reset link');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ControlBox(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Forgot Password',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onChanged: (text) {
                      email = text;
                    },
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        suffixIcon: Icon(Icons.alternate_email)),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  if (isSubmitting) const LinearProgressIndicator(),
                  16.vSpace(),
                  Row(
                    children: [
                      FilledButton(
                          onPressed: isSubmitting ? null : resetPassword,
                          child: const Text('Reset Password')),
                      16.hSpace(),
                      OutlinedButton(
                          onPressed: isSubmitting
                              ? null
                              : () {
                                  context.goNamed(RoutePaths.signIn);
                                },
                          child: const Text('Sign In'))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
