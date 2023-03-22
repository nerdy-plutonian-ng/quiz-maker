import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'control_box.dart';

class StatsWidget extends StatefulWidget {
  const StatsWidget({Key? key}) : super(key: key);

  @override
  State<StatsWidget> createState() => _StatsWidgetState();
}

class _StatsWidgetState extends State<StatsWidget> {
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
    final deviceWidth = MediaQuery.of(context).size.width;

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
              final account = snapshot.data!.data()!;
              print('--------');
              print(snapshot.data!.data());

              return ListView(
                children: [
                  Card(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Summary',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          title: const Text('Number of quizzes played'),
                          trailing: Text(
                            (account['noQuizzesPlayed'] as int).toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        ListTile(
                          title: const Text('Number of solo quizzes played'),
                          trailing: Text(
                            (account['noSoloQuizzesPlayed'] as int).toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        ListTile(
                          title: const Text('Number of group quizzes won'),
                          trailing: Text(
                            (account['noQuizzesWon'] as int).toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        ListTile(
                          title: const Text('Number of points accumulated'),
                          trailing: Text(
                            (account['noPointsAccumulated'] as int).toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        ListTile(
                          title: const Text('Times others played your quizzes'),
                          trailing: Text(
                            (account['popularityPoints'] as int).toString(),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
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
