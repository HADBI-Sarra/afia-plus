import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: appColorScheme,
  fontFamily: 'Syne',
  textTheme: const TextTheme(
    bodyLarge: TextStyle(fontWeight: FontWeight.w400), // Regular
    bodyMedium: TextStyle(fontWeight: FontWeight.w500), // Medium
    titleMedium: TextStyle(
      color: blackColor,
      fontWeight: FontWeight.w600
    ), // SemiBold
    titleLarge: TextStyle(
      color: blackColor,
      fontWeight: FontWeight.w700
    ), // Bold
    headlineLarge: TextStyle(
      color: blackColor,
      fontWeight: FontWeight.w800
    ), // ExtraBold
  ),
);

const ColorScheme appColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: darkGreenColor,
  onPrimary: whiteColor,
  secondary: blueGreenColor,
  onSecondary: whiteColor,
  surface: backgroundLightGreenColor,
  onSurface: greyColor,
  surfaceContainerHigh: whiteColor,
  error: redColor,
  onError: whiteColor,
  outline: lightGreyColor,
);