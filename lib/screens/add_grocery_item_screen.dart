import 'package:flutter/material.dart';

class AddGroceryItemScreen extends StatefulWidget {
  const AddGroceryItemScreen({super.key});

  @override
  State<AddGroceryItemScreen> createState() => _AddGroceryItemScreenState();
}

class _AddGroceryItemScreenState extends State<AddGroceryItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Grocery Item'),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Form"),
        ),
      ),
    );
  }
}
