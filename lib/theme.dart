import 'package:flutter/material.dart';

ThemeData theme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color(0xff4cbe61),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    isDense: true,
  ),
  useMaterial3: true,
);
