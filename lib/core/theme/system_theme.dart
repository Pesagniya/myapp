import 'package:flutter/material.dart';

ThemeData systemTheme = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: const Color.fromARGB(255, 255, 31, 15),
    secondary: const Color.fromARGB(255, 252, 187, 187),
    tertiary: Colors.white,
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
  ),
);
