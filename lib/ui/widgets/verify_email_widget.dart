import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_maker/data/models/type_definitions.dart';
import 'package:quiz_maker/ui/screens/auth.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';

class VerifyEmailWidget extends StatefulWidget {
  const VerifyEmailWidget({Key? key, required this.changeAuthAction})
      : super(key: key);

  final ChangeAuthAction changeAuthAction;

  @override
  State<VerifyEmailWidget> createState() => _VerifyEmailWidgetState();
}

class _VerifyEmailWidgetState extends State<VerifyEmailWidget> {
  late Timer timer;
  var secondsLeft = 60;

  countDown(Timer timer) {
    setState(() {
      secondsLeft -= 1;
    });
    if (secondsLeft == 0) {
      timer.cancel();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), countDown);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        32.vSpace(),
        Text(FirebaseAuth.instance.currentUser?.email ?? 'N/A'),
        FilledButton(
          onPressed: secondsLeft == 0
              ? () {
                  setState(() {
                    secondsLeft = 300;
                  });
                  timer = Timer.periodic(const Duration(seconds: 1), countDown);
                  FirebaseAuth.instance.currentUser?.sendEmailVerification();
                }
              : null,
          child: const Text('Resend Verification Email'),
        ),
        if (secondsLeft != 0) Text('$secondsLeft seconds left'),
        const Padding(
          padding: EdgeInsets.all(8),
          child: SizedBox(width: 64, child: Divider()),
        ),
        OutlinedButton(
          onPressed: () => widget.changeAuthAction(AuthActions.signIn),
          child: const Text('Sign In'),
        ),
      ],
    );
  }
}
