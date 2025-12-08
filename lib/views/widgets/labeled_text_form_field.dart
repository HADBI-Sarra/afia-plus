import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:afia_plus_app/views/themes/style_simple/styles.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

class LabeledTextFormField extends StatefulWidget {
  final String label;
  final String hint;
  final bool isPassword;
  final TextEditingController? controller;
  final String? errorText;
  final void Function(String)? onChanged;
  final bool isDate;
  final bool greyLabel;
  final int? minlines;
  final TextInputType? keyboardType;

  const LabeledTextFormField({
    required this.label,
    required this.hint,
    this.isPassword = false,
    this.controller,
    this.errorText,
    this.onChanged,
    this.isDate = false,
    this.greyLabel = false,
    this.minlines,
    this.keyboardType,
    super.key,
  });

  @override
  State<LabeledTextFormField> createState() => _LabeledTextFormFieldState();
}

class _LabeledTextFormFieldState extends State<LabeledTextFormField> {
  bool obscure = true;

  Widget eyeIcon() {
    return IconButton(
      icon: Icon(
        obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
      ),
      onPressed: () {
        obscure = !obscure;
        setState(() {});
      },
    );
  }

  Widget? suffixIcon() {
    if (widget.isPassword) return eyeIcon();
    if (widget.isDate) return const Icon(Icons.calendar_today_outlined);
    return null;
  }

  void _showScrollDatePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        DateTime tempPicked = DateTime.now();

        return Container(
          height: 300,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        final day = tempPicked.day.toString().padLeft(2, '0');
                        final month = tempPicked.month.toString().padLeft(
                          2,
                          '0',
                        );
                        final year = tempPicked.year;
                        final formatted = '$day/$month/$year';
                        widget.controller?.text = formatted;

                        // 🔥 CRITICAL FIX: update Cubit/state
                        if (widget.onChanged != null) {
                          widget.onChanged!(formatted);
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Done'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: DateTime(2000, 1, 1),
                  maximumDate: DateTime.now(),
                  minimumDate: DateTime(1900, 1, 1),
                  onDateTimeChanged: (DateTime newDate) {
                    tempPicked = newDate;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(
          widget.label,
          style: widget.greyLabel
              ? Theme.of(context).textTheme.labelSmall
              : Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscure && widget.isPassword,
          cursorColor: darkGreenColor,
          controller: widget.controller,
          onChanged: widget.onChanged,
          readOnly: widget.isDate,
          minLines: widget.isPassword ? 1 : widget.minlines,
          maxLines: widget.isPassword ? 1 : widget.minlines,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hint,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            enabledBorder: inputBorder,
            focusedBorder: focusedInputBorder,
            errorBorder: errorInputBorder,
            focusedErrorBorder: errorInputBorder,
            disabledBorder: inputBorder,
            filled: true,
            fillColor: blurWhiteColor,
            suffixIcon: suffixIcon(),
            errorText: widget.errorText,
          ),
          onTap: widget.isDate ? _showScrollDatePicker : null,
        ),
      ],
    );
  }
}
