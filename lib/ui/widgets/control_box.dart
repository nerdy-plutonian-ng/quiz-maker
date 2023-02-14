import 'package:flutter/material.dart';

class ControlBox extends StatelessWidget {
  const ControlBox({Key? key, required this.child, required this.isMobile})
      : super(key: key);

  final bool isMobile;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: isMobile ? double.infinity : 480,
        child: Align(alignment: Alignment.center, child: child),
      ),
    );
  }
}
