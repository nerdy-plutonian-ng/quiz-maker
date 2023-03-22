import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/send_verification_timer_state.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  late Timer timer;
  late int secondsLeft;

  countDown(Timer timer) {
    setState(() {
      secondsLeft -= 1;
    });
    if (secondsLeft <= 0) {
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
    final nextTime =
        Provider.of<SendVerificationTimerState>(context, listen: false)
            .nextTime;
    final seconds = nextTime.difference(DateTime.now()).inSeconds;
    secondsLeft = seconds < 0 ? 0 : seconds;
    timer = Timer.periodic(const Duration(seconds: 1), countDown);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Send Email Verification Link'),
        ),
        body: Consumer<SendVerificationTimerState>(
          builder: (_, state, __) {
            return SizedBox.expand(
              child: Column(
                children: [
                  32.vSpace(),
                  Text(FirebaseAuth.instance.currentUser?.email ?? 'N/A'),
                  FilledButton(
                    onPressed: state.nextTime.isBefore(DateTime.now())
                        ? () async {
                            timer = Timer.periodic(
                                const Duration(seconds: 1), countDown);
                            FirebaseAuth.instance.currentUser
                                ?.sendEmailVerification();
                            final nextTimes = await state.setNextTime();
                            if (nextTimes != null) {
                              setState(() {
                                secondsLeft = (DateTime.parse(
                                        nextTimes['nextTime'] as String))
                                    .difference(DateTime.now())
                                    .inSeconds;
                              });
                              timer = Timer.periodic(
                                  const Duration(seconds: 1), countDown);
                            }
                          }
                        : null,
                    child: const Text('Resend Verification Email'),
                  ),
                  if (secondsLeft > 0) Text('$secondsLeft seconds left'),
                  const Padding(
                    padding: EdgeInsets.all(8),
                    child: SizedBox(width: 64, child: Divider()),
                  ),
                  OutlinedButton(
                    onPressed: () => context.goNamed(RoutePaths.signIn),
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
