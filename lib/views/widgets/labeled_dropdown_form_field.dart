import 'package:flutter/material.dart';
import '../themes/style_simple/colors.dart';
import '../themes/style_simple/styles.dart';

class LabeledDropdownFormField<T> extends StatelessWidget {
  final String label;
  final List<T> items;
  final T? value;
  final void Function(T?)? onChanged;
  final String? errorText;
  final bool greyLabel;
  final String? hint;

  const LabeledDropdownFormField({
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.errorText,
    this.greyLabel = false,
    this.hint,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final labelStyle = greyLabel ? Theme.of(context).textTheme.labelSmall : Theme.of(context).textTheme.labelMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 4),
        Text(label, style: labelStyle),
        SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                item.toString(),
                style: textStyle,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textStyle,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: focusedInputBorder,
            errorBorder: errorInputBorder,
            focusedErrorBorder: errorInputBorder,
            filled: true,
            fillColor: blurWhiteColor,
            errorText: errorText,
          ),
          dropdownColor: whiteColor,
          style: textStyle,
        ),
      ],
    );
  }
}