import 'package:flutter/material.dart';

class Messager {
  static showSnackBar(
      {required BuildContext context,
      required String message,
      isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          fontSize: 18,
          color: isError
              ? Theme.of(context).colorScheme.onError
              : Theme.of(context).colorScheme.onPrimary,
        ),
        textAlign: TextAlign.center,
      ),
      backgroundColor: isError
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.primary,
    ));
  }

  static Future<bool> confirmDelete(
      BuildContext context, String question) async {
    return await showDialog<bool>(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: const Text('Confirm Delete'),
                content: Text(question),
                actions: [
                  FilledButton(
                      onPressed: () {
                        Navigator.pop(context, true);
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
  }

  static movePage(int page, PageController controller) {
    controller.animateToPage(page,
        duration: const Duration(seconds: 1), curve: Curves.easeIn);
  }
}
