import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/widgets/control_box.dart';

import '../../data/models/quiz.dart';

class PrepScreen extends StatefulWidget {
  const PrepScreen({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<PrepScreen> createState() => _PrepScreenState();
}

class _PrepScreenState extends State<PrepScreen> {
  late Future<Quiz?> quizFuture;

  Future<Quiz?> getQuiz() async {
    try {
      final quizDoc = await FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.id)
          .get();
      return Quiz.fromJson(quizDoc.data()!);
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    quizFuture = getQuiz();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: ControlBox(
          child: FutureBuilder<Quiz?>(
        future: quizFuture,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError || snapshot.data == null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'An error occurred, try again',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    FilledButton(onPressed: () {}, child: const Text('Retry')),
                  ],
                ),
              );
            }
            final quiz = snapshot.data!;
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    quiz.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  8.vSpace(),
                  Text(
                    quiz.description,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  8.vSpace(),
                  Text('${quiz.questions.length} Questions'),
                  16.vSpace(),
                  FilledButton.icon(
                      icon: const Icon(Icons.play_circle_outline),
                      onPressed: () {
                        context.pushNamed(RoutePaths.soloQuiz,
                            extra: quiz,
                            queryParams: {
                              'quizId': widget.id,
                              'maker': quiz.userId
                            });
                      },
                      label: const Text('Play'))
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      )),
    );
  }
}
