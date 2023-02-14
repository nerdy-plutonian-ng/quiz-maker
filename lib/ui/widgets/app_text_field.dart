import 'package:flutter/material.dart';
import 'package:quiz_maker/ui/utilities/app_type_defs.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.lines = 1,
    this.isEnabled = true,
    this.onChange,
    this.label,
    this.iconData,
    this.maxLength,
    this.controller,
    this.shouldValidate = true,
    this.hint,
    this.isDense = false,
    this.isFilled = false,
    this.initialValue,
  }) : super(key: key);

  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final int lines;
  final bool isEnabled;
  final TextOnChangeDef? onChange;
  final String? label;
  final IconData? iconData;
  final int? maxLength;
  final TextEditingController? controller;
  final bool shouldValidate;
  final String? hint;
  final bool isDense;
  final bool isFilled;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      controller: controller,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      maxLines: lines,
      maxLength: maxLength,
      enabled: isEnabled,
      onChanged: onChange,
      decoration: InputDecoration(
        filled: isFilled,
        isDense: isDense,
        hintText: hint,
        labelText: label,
        suffixIcon: Icon(iconData),
      ),
      validator: (text) {
        if (shouldValidate && (text == null || text.isEmpty)) return 'Required';
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
