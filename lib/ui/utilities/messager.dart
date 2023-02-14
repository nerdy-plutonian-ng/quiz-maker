import 'package:flutter/material.dart';

class Messager {
  static showSnackBar(
      {required BuildContext context,
      required String message,
      bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(fontSize: 18, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
    ));
  }
}
