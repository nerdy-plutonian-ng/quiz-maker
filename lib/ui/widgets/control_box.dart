import 'package:flutter/material.dart';
import 'package:quiz_maker/data/constants/app_dimensions.dart';

class ControlBox extends StatelessWidget {
  const ControlBox({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: deviceWidth <= AppDimensions.mobileWidth
            ? double.infinity
            : AppDimensions.mobileWidth.toDouble(),
        child: Align(alignment: Alignment.center, child: child),
      ),
    );
  }
}
