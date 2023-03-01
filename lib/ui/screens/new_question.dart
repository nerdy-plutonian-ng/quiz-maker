import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/create_quiz_state.dart';
import 'package:quiz_maker/data/constants/app_dimensions.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/utilities/messager.dart';
import 'package:quiz_maker/ui/widgets/app_text_field.dart';
import 'package:quiz_maker/ui/widgets/control_box.dart';

class NewQuestionScreen extends StatefulWidget {
  const NewQuestionScreen({Key? key, required this.params, this.index})
      : super(key: key);

  final Map<String, String> params;
  final int? index;

  @override
  State<NewQuestionScreen> createState() => _NewQuestionScreenState();
}

class _NewQuestionScreenState extends State<NewQuestionScreen> {
  late Map<String, dynamic> question;

  late Map<String, dynamic> stagedQuestion;

  late List<int> indices;

  final _formKey = GlobalKey<FormState>();

  late TextEditingController questionTEC;

  addEditQuestion() {
    if (_formKey.currentState!.validate()) {
      if (stagedQuestion['answer'] == -1) {
        Messager.showSnackBar(
            context: context, message: 'Select an answer', isError: true);
        return;
      }
      final quizState = Provider.of<CreateQuizState>(context, listen: false);
      if (quizState.index == null) {
        quizState.addQuestion(stagedQuestion);
      } else {
        quizState.updateQuestion(quizState.index!, stagedQuestion);
      }
      quizState.resetIndex();
      context.pop();
    }
  }

  @override
  void dispose() {
    questionTEC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    question = jsonDecode(widget.params['question']!);
    stagedQuestion = {...question};
    indices = List<int>.generate(
        (stagedQuestion['choices'] as List).length, (index) => index);
    questionTEC = TextEditingController(text: stagedQuestion['title']);
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${(question['title'] as String).isEmpty ? 'New' : 'Edit'} Question'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                if (deviceWidth > AppDimensions.portraitTabletWidth)
                  Expanded(
                      child: Align(
                    alignment: Alignment.topCenter,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AppTextField(
                          controller: questionTEC,
                          maxLength: 50,
                          label: 'Question',
                          textInputAction: TextInputAction.done,
                          onChange: (text) {
                            stagedQuestion['title'] = text;
                          },
                        ),
                      ),
                    ),
                  )),
                if (deviceWidth > AppDimensions.portraitTabletWidth)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: VerticalDivider(),
                  ),
                Expanded(
                    flex: 2,
                    child: ControlBox(
                      isMobile: deviceWidth <= AppDimensions.mobileWidth,
                      child: ListView(
                        children: [
                          if (deviceWidth <= AppDimensions.portraitTabletWidth)
                            AppTextField(
                              controller: questionTEC,
                              maxLength: 50,
                              label: 'Question',
                              textInputAction: TextInputAction.done,
                              onChange: (text) {
                                stagedQuestion['title'] = text;
                              },
                            ),
                          16.vSpace(),
                          Text(
                            'Answers',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          for (var index in indices)
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              value: index == stagedQuestion['answer'],
                              onChanged: (value) {
                                if (value!) {
                                  setState(() {
                                    stagedQuestion['answer'] = index;
                                  });
                                }
                              },
                              title: AppTextField(
                                maxLength: 50,
                                initialValue: question['choices'][index],
                                label: 'Choice ${index + 1}',
                                textInputAction: TextInputAction.done,
                                onChange: (text) {
                                  stagedQuestion['choices'][index] = text;
                                },
                              ),
                            ),
                          16.vSpace(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FilledButton(
                                    onPressed: addEditQuestion,
                                    child: Text(
                                        '${(question['title'] as String).isEmpty ? 'Add' : 'Update'} Question')),
                                16.hSpace(),
                                OutlinedButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text('Cancel')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
