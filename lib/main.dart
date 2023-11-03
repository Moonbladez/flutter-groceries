import 'package:flutter/material.dart';
import 'package:flutter_shopping/screens/screens.dart';
import 'package:flutter_shopping/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Shopping',
      theme: theme,
      home: const GroceriesListScreen(),
    );
  }
}
