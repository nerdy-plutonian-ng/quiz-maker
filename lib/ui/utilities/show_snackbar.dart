import 'package:flutter/material.dart';

class AppSnackBar {
  static showSnackBar(
      {required BuildContext context,
      required String message,
      isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 18, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      backgroundColor: isError
          ? Theme.of(context).colorScheme.error
          : Theme.of(context).colorScheme.secondary,
    ));
  }
}
