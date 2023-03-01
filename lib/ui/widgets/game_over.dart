import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/single_quiz_state.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';

class GameOverWidget extends StatefulWidget {
  const GameOverWidget({Key? key}) : super(key: key);

  @override
  State<GameOverWidget> createState() => _GameOverWidgetState();
}

class _GameOverWidgetState extends State<GameOverWidget> {
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((account) {
      final newAccount = {
        'account': {
          'noPointsAccumulated': 0,
          'noQuizzesPlayed': 0,
          'noQuizzesWon': 0
        }
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.email)
          .update({
        'account.noQuizzesPlayed':
            (account['account']['noQuizzesPlayed'] as int) + 1,
        'account.noPointsAccumulated':
            (account['account']['noPointsAccumulated'] as int) +
                Provider.of<SingleQuizState>(context, listen: false).score
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final quiz = Provider.of<SingleQuizState>(context, listen: false);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Quiz Over',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          16.vSpace(),
          Text(
            'You scored ${quiz.score} out of ${quiz.quiz!.questions.length * 3} points',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          32.vSpace(),
          FilledButton.icon(
            onPressed: () {
              context.goNamed(RoutePaths.root);
              //quiz.reset();
            },
            icon: const Icon(Icons.home_outlined),
            label: const Text('Home'),
          )
        ],
      ),
    );
  }
}
