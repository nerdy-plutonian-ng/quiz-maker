import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/single_quiz_state.dart';

class TickerWidget extends StatefulWidget {
  const TickerWidget({Key? key}) : super(key: key);

  @override
  State<TickerWidget> createState() => _TickerWidgetState();
}

class _TickerWidgetState extends State<TickerWidget> {
  late Timer timer;
  static const minTime = Duration(seconds: 1);

  countDown(Timer timer) {
    //Provider.of<SingleQuizState>(context, listen: false).decreaseSeconds();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(minTime, countDown);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SingleQuizState>(builder: (_, quiz, __) {
      return ListTile();
      // return ListTile(
      //   leading: CircularProgressIndicator(
      //     value: (quiz.secondsLeft * (20.0 / 3.0)) / 100,
      //   ),
      //   title: Text('${quiz.secondsLeft} second(s) left'),
      // );
    });
  }
}
