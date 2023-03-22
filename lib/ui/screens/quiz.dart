import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/quiz_state.dart';
import 'package:quiz_maker/data/constants/app_dimensions.dart';
import 'package:quiz_maker/data/models/quiz.dart';
import 'package:quiz_maker/ui/utilities/messager.dart';

import '../widgets/questions.dart';
import '../widgets/title_and _description.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  var quizTitle = '';
  var quizDescription = '';
  var questions = <Question>[];
  late bool isFetching;
  bool isSubmitting = false;

  submit() {
    final quizState = Provider.of<QuizState>(context, listen: false);
    if (quizState.title == null || quizState.title!.isEmpty) {
      Messager.showSnackBar(
          context: context, message: 'Enter a title', isError: true);
      return;
    }
    if (quizState.description == null || quizState.description!.isEmpty) {
      Messager.showSnackBar(
          context: context, message: 'Enter a description', isError: true);
      return;
    }
    if (quizState.questions == null || quizState.questions!.isEmpty) {
      Messager.showSnackBar(
          context: context, message: 'Add a question', isError: true);
      return;
    }
    setState(() {
      isSubmitting = true;
    });
    final quiz = Quiz(
        userId: FirebaseAuth.instance.currentUser!.uid,
        title: quizState.title!,
        description: quizState.description!,
        popularity: 0,
        questions: quizState.questions!);
    if (widget.id == null) {
      FirebaseFirestore.instance
          .collection('quizzes')
          .add(quiz.toJson())
          .then((result) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((doc) {
          final quiz = {...?doc.data()};
          final quizzes = quiz['quizzes'] ?? <Map<String, String?>>[];
          quizzes.add({'id': result.id, 'title': quizState.title});
          quiz['quizzes'] = quizzes;
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(quiz)
              .then((value) {
            Messager.showSnackBar(
              context: context,
              message: 'Added Quiz successfully',
            );
            quizState.reset();
            context.pop();
          });
        }).catchError((e) {
          setState(() {
            isSubmitting = true;
          });
          Messager.showSnackBar(
              context: context, message: e.toString(), isError: true);
        });
      }).catchError((e) {
        setState(() {
          isSubmitting = true;
        });
        Messager.showSnackBar(
            context: context, message: e.toString(), isError: true);
      });
    } else {
      FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.id)
          .update(quiz.toJson())
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then((doc) {
          final account = {...?doc.data()};
          final quizzes = account['quizzes'] ?? <Map<String, String?>>[];
          final index = (quizzes as List)
              .indexWhere((element) => element['id'] == widget.id);
          quizzes[index] = {'id': widget.id, 'title': quiz.title};
          account['quizzes'] = quizzes;
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update(account)
              .then((value) {
            Messager.showSnackBar(
              context: context,
              message: 'Updated quiz successfully',
            );
            quizState.reset();
            context.pop();
          });
        }).catchError((e) {
          setState(() {
            isSubmitting = true;
          });
          print(e);
          Messager.showSnackBar(
              context: context, message: e.toString(), isError: true);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.id == null) {
      isFetching = false;
    } else {
      isFetching = true;
      FirebaseFirestore.instance
          .collection('quizzes')
          .doc(widget.id)
          .get()
          .then((quizShot) {
        final quiz = quizShot.data();
        // quizTitle = quiz?['title'];
        // quizDescription = quiz?['description'];
        // questions = Question.questionsFromJson(jsonEncode(quiz?['questions']));
        final quizState = Provider.of<QuizState>(context, listen: false);
        quizState.setTitle(quiz?['title']);
        quizState.setDescription(quiz?['description']);
        quizState.setQuestions(
            Question.questionsFromJson(jsonEncode(quiz?['questions'])));
        setState(() {
          isFetching = false;
        });
      }).catchError((e) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'New Quiz' : 'Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8),
            child: FilledButton(
              onPressed: isFetching || isSubmitting ? null : submit,
              style: FilledButton.styleFrom(
                  visualDensity:
                      deviceWidth <= AppDimensions.portraitTabletWidth
                          ? VisualDensity.compact
                          : VisualDensity.standard),
              child: Text(widget.id == null ? 'Save' : 'Update'),
            ),
          ),
          if (isSubmitting)
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      body: isFetching
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (deviceWidth > AppDimensions.portraitTabletWidth)
                    Expanded(
                        child: ListView(
                      children: const [
                        TitleAndDescription(),
                      ],
                    )),
                  if (deviceWidth > AppDimensions.portraitTabletWidth)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: VerticalDivider(),
                    ),
                  const Expanded(flex: 2, child: Questions()),
                ],
              ),
            ),
    );
  }
}
