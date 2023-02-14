import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/create_quiz_state.dart';
import 'package:quiz_maker/data/constants/app_dimensions.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/widgets/control_box.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Stream<QuerySnapshot<Map<String, dynamic>>> accountStream;

  @override
  void initState() {
    super.initState();
    accountStream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('quizzes')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return ControlBox(
      isMobile: deviceWidth <= AppDimensions.mobileWidth,
      child: StreamBuilder(
          stream: accountStream,
          builder: (_, snapshot) {
            if (!snapshot.hasError) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final quizzes = snapshot.data!.docs;

              return Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: const Text('Created Quizzes'),
                        subtitle: quizzes.isEmpty
                            ? const Text('You have no quizzes')
                            : null,
                        trailing: FilledButton.icon(
                            style: FilledButton.styleFrom(
                                visualDensity: VisualDensity.compact),
                            onPressed: () {
                              Provider.of<CreateQuizState>(context,
                                      listen: false)
                                  .setQuestions(<Map<String, dynamic>>[]);
                              context
                                  .pushNamed(RoutePaths.newQuiz, queryParams: {
                                'quiz': jsonEncode({
                                  'title': '',
                                  'questions': <Map<String, dynamic>>[],
                                })
                              });
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('New quiz')),
                      ),
                    ),
                  ),
                  16.vSpace(),
                  Expanded(
                      child: ListView.builder(
                    itemBuilder: (_, index) {
                      return ListTile(
                        onTap: () {
                          Provider.of<CreateQuizState>(context, listen: false)
                              .setQuestions(
                                  (quizzes[index].data()['questions'] as List)
                                      .map((e) => e as Map<String, dynamic>)
                                      .toList());
                          context.pushNamed(RoutePaths.newQuiz, queryParams: {
                            'quiz': jsonEncode(quizzes[index].data()),
                            'id': quizzes[index].id
                          });
                        },
                        title: Text(quizzes[index].data()['title']),
                        trailing: const Icon(Icons.navigate_next),
                      );
                    },
                    itemCount: quizzes.length,
                  ))
                ],
              );
            }
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Oops...an error occurred.'),
                  FilledButton(
                      onPressed: () {
                        setState(() {
                          accountStream = FirebaseFirestore.instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser!.email)
                              .collection('quizzes')
                              .snapshots();
                        });
                      },
                      child: const Text('Try Again')),
                ],
              ),
            );
          }),
    );
  }
}
