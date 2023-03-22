import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/quiz_state.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/widgets/control_box.dart';

import '../utilities/messager.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> accountStream;

  @override
  void initState() {
    super.initState();
    accountStream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return ControlBox(
      child: StreamBuilder(
          stream: accountStream,
          builder: (_, snapshot) {
            if (!snapshot.hasError) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final quizzes = snapshot.data!.data()?['quizzes'] as List? ?? [];

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
                        trailing: SizedBox(
                          child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                  visualDensity: VisualDensity.compact),
                              onPressed: () {
                                Provider.of<QuizState>(context, listen: false)
                                    .reset();
                                context.pushNamed(
                                  RoutePaths.quiz,
                                );
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('New quiz')),
                        ),
                      ),
                    ),
                  ),
                  16.vSpace(),
                  Expanded(
                      child: ListView.separated(
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (_, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: const [
                              Padding(
                                padding: EdgeInsets.only(right: 16.0),
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              )
                            ],
                          ),
                        ),
                        onDismissed: (_) {
                          quizzes.removeAt(index);
                        },
                        confirmDismiss: (_) async {
                          await showDialog<bool>(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      title: const Text('Confirm Delete'),
                                      content: Text(quizzes[index]['title']),
                                      actions: [
                                        FilledButton(
                                            onPressed: () {
                                              FirebaseFirestore.instance
                                                  .collection('quizzes')
                                                  .doc(quizzes[index]['id'])
                                                  .delete()
                                                  .then((_) {
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(FirebaseAuth.instance
                                                        .currentUser!.uid)
                                                    .get()
                                                    .then((doc) {
                                                  final account = {
                                                    ...?doc.data()
                                                  };
                                                  final quizzes = account[
                                                          'quizzes'] ??
                                                      <Map<String, String?>>[];
                                                  final deleteIndex = (quizzes
                                                          as List)
                                                      .indexWhere((element) =>
                                                          element['id'] ==
                                                          quizzes[index]['id']);
                                                  quizzes.removeAt(deleteIndex);
                                                  account['quizzes'] = quizzes;
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(FirebaseAuth.instance
                                                          .currentUser!.uid)
                                                      .update(account)
                                                      .then((value) {
                                                    Messager.showSnackBar(
                                                      context: context,
                                                      message:
                                                          'Quiz deleted successfully',
                                                    );
                                                    context.pop();
                                                  });
                                                }).catchError((e) {
                                                  Messager.showSnackBar(
                                                      context: context,
                                                      message:
                                                          'Error deleting quiz, try again',
                                                      isError: true);
                                                });
                                              });
                                            },
                                            child: const Text('Delete')),
                                        FilledButton.tonal(
                                            onPressed: () {
                                              Navigator.pop(context, false);
                                            },
                                            child: const Text('Cancel')),
                                      ],
                                    );
                                  }) ??
                              false;
                        },
                        child: ListTile(
                          onTap: () {
                            context.pushNamed(RoutePaths.quiz,
                                queryParams: {'id': quizzes[index]['id']});
                          },
                          title: Text(quizzes[index]['title']),
                          trailing: const Icon(Icons.navigate_next),
                        ),
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
                              .doc(FirebaseAuth.instance.currentUser!.uid)
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
