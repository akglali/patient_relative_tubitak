import 'package:flutter/material.dart';

import '../size_config.dart';

class RoundedButton extends StatelessWidget {
  final String name;
  final Color bgColor;
  final Color primaryColor;
  final VoidCallback function;
  final double? size;

  RoundedButton({
    required this.name,
    required this.bgColor,
    required this.primaryColor,
    required this.function,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: bgColor,
        primary: primaryColor,
        padding: EdgeInsets.symmetric(
            vertical: getProportionateScreenHeight(15),
            horizontal: getProportionateScreenWidth(30)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
        ),
      ),
      onPressed: function,
      child: Text(
        name,
        style: TextStyle(fontSize: size),
      ),
    );
  }
}
