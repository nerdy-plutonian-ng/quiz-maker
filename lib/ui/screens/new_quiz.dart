import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/create_quiz_state.dart';
import 'package:quiz_maker/data/constants/route_paths.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/utilities/show_snackbar.dart';
import 'package:quiz_maker/ui/widgets/question_view.dart';

import '../../data/constants/app_dimensions.dart';
import '../widgets/app_text_field.dart';
import '../widgets/control_box.dart';

class NewQuizScreen extends StatefulWidget {
  const NewQuizScreen({
    Key? key,
    required this.quiz,
  }) : super(key: key);

  final Map<String, String> quiz;

  @override
  State<NewQuizScreen> createState() => _NewQuizScreenState();
}

class _NewQuizScreenState extends State<NewQuizScreen> {
  late Map<String, dynamic> quiz;
  late Map<String, dynamic> stagedQuiz;
  int selectedQuestion = -1;
  final _formKey = GlobalKey<FormState>();
  var isPosting = false;
  late String id;

  addUpdateQuiz() {
    if (_formKey.currentState!.validate()) {
      if (Provider.of<CreateQuizState>(context, listen: false)
          .questions
          .isEmpty) {
        AppSnackBar.showSnackBar(
            context: context,
            message: 'Your quiz has no questions',
            isError: true);
        return;
      }
      final newQuiz = {
        'title': stagedQuiz['title'],
        'questions':
            Provider.of<CreateQuizState>(context, listen: false).questions,
      };
      //print(newQuiz);
      setState(() {
        isPosting = true;
      });
      if ((quiz['title'] as String).isEmpty) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('quizzes')
            .add(newQuiz)
            .then((value) {
          AppSnackBar.showSnackBar(
            context: context,
            message: 'Successfully added',
          );
          Navigator.pop(context);
        }).catchError((error) {
          setState(() {
            isPosting = false;
          });
          AppSnackBar.showSnackBar(
              context: context, message: error.toString(), isError: true);
        });
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('quizzes')
            .doc(id)
            .set(newQuiz)
            .then((value) {
          AppSnackBar.showSnackBar(
            context: context,
            message: 'Successfully updated',
          );
          Navigator.pop(context);
        }).catchError((error) {
          setState(() {
            isPosting = false;
          });
          AppSnackBar.showSnackBar(
              context: context, message: error.toString(), isError: true);
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    quiz = jsonDecode(widget.quiz['quiz']!);
    stagedQuiz = {...quiz};
    id = widget.quiz['id'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final quizQuestions = Provider.of<CreateQuizState>(context);
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                  '${(quiz['title'] as String).isEmpty ? 'New' : 'Update'} Quiz'),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: FilledButton(
                    style: FilledButton.styleFrom(
                        visualDensity: VisualDensity.compact),
                    onPressed: isPosting ? null : addUpdateQuiz,
                    child: Text(
                        '${(quiz['title'] as String).isEmpty ? 'Save' : 'Update'} Quiz')),
              ),
              if (isPosting)
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator()),
                )
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                      child: ControlBox(
                    isMobile: deviceWidth <= AppDimensions.mobileWidth,
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: _formKey,
                                child: AppTextField(
                                  textInputAction: TextInputAction.done,
                                  initialValue: quiz['title'],
                                  label: 'Quiz Title',
                                  maxLength: 50,
                                  onChange: (text) {
                                    stagedQuiz['title'] = text;
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(child: 16.vSpace()),
                        SliverToBoxAdapter(
                            child: ListTile(
                          title: const Text('Questions'),
                          subtitle: quizQuestions.questions.isEmpty
                              ? const Text('You have not added questions yet')
                              : null,
                          trailing: IconButton(
                            onPressed: () {
                              Provider.of<CreateQuizState>(context,
                                      listen: false)
                                  .resetIndex();
                              context.pushNamed(RoutePaths.newQuestion,
                                  queryParams: {
                                    'question': jsonEncode({
                                      'title': '',
                                      'choices': ['', '', '', ''],
                                      'answer': -1,
                                    })
                                  });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        )),
                        if (quizQuestions.questions.isNotEmpty)
                          SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (context, index) => Card(
                                        child: ListTile(
                                          onTap: () {
                                            if (deviceWidth <=
                                                AppDimensions
                                                    .portraitTabletWidth) {
                                              Provider.of<CreateQuizState>(
                                                      context,
                                                      listen: false)
                                                  .selectIndex(index);
                                              context.pushNamed(
                                                  RoutePaths.newQuestion,
                                                  queryParams: {
                                                    'question': jsonEncode(
                                                        quizQuestions
                                                            .questions[index])
                                                  });
                                            } else {
                                              setState(() {
                                                selectedQuestion = index;
                                              });
                                            }
                                          },
                                          title: Text(quizQuestions
                                              .questions[index]['title']),
                                        ),
                                      ),
                                  childCount: quizQuestions.questions.length)),
                      ],
                    ),
                  )),
                  if (deviceWidth > AppDimensions.portraitTabletWidth)
                    const VerticalDivider(),
                  if (deviceWidth > AppDimensions.portraitTabletWidth)
                    Expanded(
                        flex: 2,
                        child: selectedQuestion == -1
                            ? Container()
                            : ControlBox(
                                isMobile:
                                    deviceWidth <= AppDimensions.mobileWidth,
                                child: QuestionViewWidget(
                                    question: quizQuestions
                                        .questions[selectedQuestion],
                                    index: selectedQuestion),
                              )),
                ],
              )),
        ));
  }
}
