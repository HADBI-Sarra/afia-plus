import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

class PasswordErrorText extends StatefulWidget {
  final String text;
  final bool control;

  const PasswordErrorText({
    required this.text,
    required this.control,
    super.key,
  });

  @override
  State<PasswordErrorText> createState() => _PasswordErrorTextState();
}

class _PasswordErrorTextState extends State<PasswordErrorText> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          widget.control ? Icons.check : Icons.close,
          color: widget.control ? greenColor : redColor,
          size: 12,
        ),
        const SizedBox(width: 5),
        Text(
          widget.text,
          style: TextStyle(
            color: widget.control ? greenColor : redColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}