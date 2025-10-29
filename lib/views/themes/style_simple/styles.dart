import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

const gradientBackgroundDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      gradientGreenColor,
      backgroundLightGreenColor,
      backgroundLightGreenColor,
      gradientGreenColor,
    ],
  ),
);