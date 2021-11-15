
import 'package:flutter/material.dart';

import '../size_config.dart';

class FormTextField extends StatelessWidget {
  final String hint;
  final IconData prefixIcon;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? suffixIcon;

  FormTextField(
      {required this.hint,
      required this.prefixIcon,
      required this.controller,
      this.obscureText = false,
      this.validator,
      this.suffixIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(15),
        horizontal: getProportionateScreenWidth(18),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator != null ? validator! : null,
        decoration: InputDecoration(
            isDense: true,
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.withOpacity(0.4),
            prefixIcon: Icon(prefixIcon),
            suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            )),
      ),
    );
  }
}
