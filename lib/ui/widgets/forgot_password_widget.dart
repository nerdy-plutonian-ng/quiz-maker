import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker/data/models/type_definitions.dart';
import 'package:quiz_maker/ui/screens/auth.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/utilities/messager.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({Key? key, required this.changeAuthAction})
      : super(key: key);

  final ChangeAuthAction changeAuthAction;

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidgetState();
}

class _ForgotPasswordWidgetState extends State<ForgotPasswordWidget> {
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
        widget.changeAuthAction(AuthActions.signIn);
        Messager.showSnackBar(
            context: context,
            message: 'Check your mail for a password reset link');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onChanged: (text) {
                email = text;
              },
              decoration: const InputDecoration(
                  labelText: 'Email', suffixIcon: Icon(Icons.alternate_email)),
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
                    onPressed: () =>
                        widget.changeAuthAction(AuthActions.signIn),
                    child: const Text('Sign In'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
