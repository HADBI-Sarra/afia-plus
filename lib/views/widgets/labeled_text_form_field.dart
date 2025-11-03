import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';


class LabeledTextFormField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const LabeledTextFormField({
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.onChanged,
    super.key,
  });

  @override
  State<LabeledTextFormField> createState() => _LabeledTextFormFieldState();
}

class _LabeledTextFormFieldState extends State<LabeledTextFormField> {
  bool obscure = true;

  Widget eyeIcon () {
    return IconButton(
      icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined),
      onPressed: () {
        obscure = obscure ? false : true;
        setState(() {});
      },
    );  
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4),
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        SizedBox(height: 8),
        TextFormField(
          obscureText: obscure && widget.isPassword,
          cursorColor: darkGreenColor,
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            contentPadding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 20,
            ),
            enabledBorder: inputBorder,
            focusedBorder: focusedInputBorder,
            errorBorder: errorInputBorder,
            focusedErrorBorder: errorInputBorder,
            disabledBorder: inputBorder,
            filled: true,
            fillColor: blurWhiteColor,
            suffixIcon: widget.isPassword ? eyeIcon() : null,
          ),
        ),
      ],
    );
  }
}