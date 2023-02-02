import 'package:flutter/cupertino.dart';

extension Spacer on int {
  SizedBox vSpace() {
    return SizedBox(
      height: toDouble(),
    );
  }

  SizedBox hSpace() {
    return SizedBox(
      width: toDouble(),
    );
  }
}
