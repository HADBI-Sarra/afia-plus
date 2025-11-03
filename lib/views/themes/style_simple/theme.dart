import 'package:flutter/material.dart';
import 'package:afia_plus_app/views/themes/style_simple/colors.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: appColorScheme,
  fontFamily: 'Syne',
  textTheme: const TextTheme(
    bodySmall: TextStyle(
      fontWeight: FontWeight.w400, // Regular
    ),
    bodyMedium: TextStyle(
      fontWeight: FontWeight.w400, // Regular
      fontSize: 16,
    ),
    titleLarge: TextStyle(
      color: blackColor,
      fontWeight: FontWeight.w700,
      fontSize: 32,
    ), // Bold
    headlineLarge: TextStyle(
      color: blackColor,
      fontWeight: FontWeight.w800
    ), // ExtraBold
    labelMedium: TextStyle(
      color: blackColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    )
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