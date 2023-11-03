import 'package:flutter/material.dart';

class EmptyGroceryList extends StatelessWidget {
  const EmptyGroceryList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No Groceries'),
    );
  }
}
