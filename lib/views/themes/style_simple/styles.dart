import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

const gradientBackgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      gradientGreenColor,
      backgroundLightGreenColor,
      backgroundLightGreenColor,
      gradientGreenColor,
    ],
  ),
);

final OutlineInputBorder inputBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: whiteColor,
    width: 1.5,
  ),
  borderRadius: BorderRadius.circular(100)
);

final OutlineInputBorder focusedInputBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: darkGreenColor,
    width: 1.5,
  ),
  borderRadius: BorderRadius.circular(100)
);

final OutlineInputBorder errorInputBorder = OutlineInputBorder(
  borderSide: BorderSide(
    color: redColor,
    width: 1.5,
  ),
  borderRadius: BorderRadius.circular(100)
);

final loginButtonStyle = ButtonStyle(
  backgroundColor: WidgetStateProperty.all(darkGreenColor),
  minimumSize: WidgetStateProperty.all(const Size(double.infinity, 50)),
);

const greenLink = TextStyle(
  color: darkGreenColor,
  fontWeight: FontWeight.w500,
);

const buttonText = TextStyle(
  color: whiteColor,
  fontWeight: FontWeight.w500,
  fontSize: 16,
);