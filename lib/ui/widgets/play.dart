import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/single_quiz_state.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';

import '../utilities/messager.dart';

class PlayWidget extends StatefulWidget {
  const PlayWidget({Key? key}) : super(key: key);

  @override
  State<PlayWidget> createState() => _PlayWidgetState();
}

class _PlayWidgetState extends State<PlayWidget> {
  var isSearching = false;
  List<QueryDocumentSnapshot>? docs;
  final controller = TextEditingController();

  searchUserQuizzes(String query) {
    setState(() {
      isSearching = true;
      docs = null;
    });
    if (query == FirebaseAuth.instance.currentUser!.email) {
      setState(() {
        isSearching = false;
      });
      Messager.showSnackBar(
        context: context,
        message: 'You are searching for yourself',
        isError: true,
      );
      return;
    }
    final usersQuizzes =
        FirebaseFirestore.instance.collection('users').doc(query);
    usersQuizzes.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        usersQuizzes.collection('quizzes').get().then((snapshot) {
          setState(() {
            docs = snapshot.docs;
            isSearching = false;
          });
        }).catchError((error) {
          setState(() {
            isSearching = false;
          });
          Messager.showSnackBar(
              context: context, message: error.toString(), isError: true);
        });
      } else {
        setState(() {
          isSearching = false;
        });
        Messager.showSnackBar(
            context: context,
            message: 'This user does not exist',
            isError: true);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CupertinoSearchTextField(
            controller: controller,
            enabled: !isSearching,
            placeholder: 'Email of quiz maker',
            onSubmitted: (query) => searchUserQuizzes(query.toLowerCase()),
            onSuffixTap: () {
              setState(() {
                docs = null;
                controller.clear();
              });
            },
          ),
          if (isSearching) const LinearProgressIndicator(),
          if (!isSearching && docs != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Quizzes',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          if (!isSearching && docs != null && docs!.isEmpty)
            Text(
              'This user has no quizzes',
              style: Theme.of(context).textTheme.labelLarge,
            ),
          if (!isSearching && docs != null)
            Expanded(
                child: ListView.builder(
              itemBuilder: (_, index) {
                final quiz = docs![index].data() as Map<String, dynamic>;
                return Card(
                  child: ListTile(
                    onTap: () {
                      Provider.of<SingleQuizState>(context, listen: false)
                          .reset();
                      Provider.of<SingleQuizState>(context, listen: false)
                          .setQuiz(quiz);
                      context.pushNamed(
                        RoutePaths.playQuiz,
                      );
                    },
                    title: Text(quiz['title']),
                    trailing: const Icon(Icons.navigate_next),
                  ),
                );
              },
              itemCount: docs!.length,
            ))
        ],
      ),
    );
  }
}
