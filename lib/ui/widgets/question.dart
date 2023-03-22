import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_maker/data/app_state/quiz_state.dart';
import 'package:quiz_maker/ui/utilities/app_extensions.dart';
import 'package:quiz_maker/ui/widgets/app_text_field.dart';

import '../../data/models/quiz.dart';

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({Key? key, this.question, this.index}) : super(key: key);

  final Question? question;
  final int? index;

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late String question;
  late List<String> options;
  int? answer;
  late List<bool> checks;
  late List<int> indices;
  var noAnswer = false;

  final _formKey = GlobalKey<FormState>();

  submit() {
    if (_formKey.currentState!.validate()) {
      if (answer == null) {
        setState(() {
          noAnswer = true;
        });
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            noAnswer = false;
          });
        });
        return;
      }
      final quizState = Provider.of<QuizState>(context, listen: false);
      if (widget.question == null) {
        quizState.addQuestion(
            Question(question: question, options: options, answer: answer!));
      } else {
        quizState.updateQuestion(widget.index!,
            Question(question: question, options: options, answer: answer!));
      }
      context.pop();
    }
  }

  @override
  void initState() {
    super.initState();
    question = widget.question?.question ?? '';
    options = widget.question?.options ?? ['', '', '', ''];
    answer = widget.question?.answer;
    indices = List<int>.generate(4, (index) => index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            AppTextField(
              label: 'Question',
              initialValue: question,
              onChange: (text) {
                question = text;
              },
            ),
            8.vSpace(),
            for (var index in indices)
              Row(
                children: [
                  Checkbox(
                      value: index == answer,
                      onChanged: (value) {
                        setState(() {
                          answer = index;
                        });
                      }),
                  Expanded(
                      child: AppTextField(
                    textInputAction: index == 3
                        ? TextInputAction.done
                        : TextInputAction.next,
                    initialValue: options[index],
                    hint: 'Option',
                    onChange: (text) {
                      options[index] = text;
                    },
                    shouldValidate: true,
                  )),
                ],
              ),
            16.vSpace(),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                  onPressed: submit,
                  child: Text(
                      '${widget.question == null ? 'Add' : 'Update'} Question')),
            ),
            if (noAnswer)
              Align(
                  alignment: Alignment.center,
                  child: Card(
                    color: Theme.of(context).colorScheme.errorContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Select an aswer',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ))
          ],
        ),
      ),
    );
  }
}
