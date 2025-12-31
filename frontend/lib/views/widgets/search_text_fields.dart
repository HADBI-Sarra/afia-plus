import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';


class SearchTextField extends StatefulWidget {

  final String hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;

  const SearchTextField({
    required this.hint,
    this.controller,
    this.validator,
    this.onChanged,
    super.key,
  });

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      
          cursorColor: darkGreenColor,
          controller: widget.controller,
          validator: widget.validator,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            hintText: widget.hint,
            contentPadding: EdgeInsets.symmetric(
              vertical: 20,
              horizontal: 20,
            ),
            enabledBorder: inputBorder,
            focusedBorder: focusedInputBorder,
            errorBorder: errorInputBorder,
            focusedErrorBorder: errorInputBorder,
            disabledBorder: inputBorder,
            filled: true,
            fillColor: blurWhiteColor,
            prefixIcon: Icon(
              Icons.search,
              size: 30,
            )
          )
        );
  }
}