import 'package:flutter/material.dart';

ThemeData theme = ThemeData.dark().copyWith(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Colors.blueGrey,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    isDense: true,
  ),
  useMaterial3: true,
);
