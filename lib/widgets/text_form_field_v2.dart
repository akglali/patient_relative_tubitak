import 'package:flutter/material.dart';

import '../size_config.dart';

class FormTextFieldV2 extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? initialValue;
  final bool enable;

  FormTextFieldV2({
    required this.controller,
    required this.hint,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.initialValue,
    this.enable=true,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
        child: TextFormField(
          controller: controller,
          enabled: enable,
          validator: validator != null ? validator! : null,
          decoration: InputDecoration(hintText: hint),
          keyboardType: keyboardType,
          maxLines: maxLines ?? 1,
        ),
      ),
    );
  }
}
