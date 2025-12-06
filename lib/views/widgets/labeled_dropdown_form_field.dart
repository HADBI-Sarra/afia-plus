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
  final String Function(T)? itemLabel; // convert T → String
  final bool isExpanded; // Add this

  const LabeledDropdownFormField({
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.errorText,
    this.greyLabel = false,
    this.hint,
    this.itemLabel,
    this.isExpanded = true, // Default to true for better UI
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final labelStyle = greyLabel
        ? Theme.of(context).textTheme.labelSmall
        : Theme.of(context).textTheme.labelMedium;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text(label, style: labelStyle),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemLabel != null ? itemLabel!(item) : item.toString(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
          isExpanded: isExpanded, // Add this
          icon: const Icon(Icons.arrow_drop_down),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textStyle?.copyWith(color: Colors.grey[600]),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            border: inputBorder,
            enabledBorder: inputBorder,
            focusedBorder: focusedInputBorder,
            errorBorder: errorInputBorder,
            focusedErrorBorder: errorInputBorder,
            filled: true,
            fillColor: blurWhiteColor,
            errorText: errorText,
            errorMaxLines: 2,
          ),
          dropdownColor: whiteColor,
          style: textStyle,
          menuMaxHeight: 300, // Limit dropdown height
        ),
      ],
    );
  }
}