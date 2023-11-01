import 'package:flutter/material.dart';
import 'package:flutter_shopping/widgets/widgets.dart';
import "package:flutter_shopping/data/dummy_items.dart";

class GroceriesListScreen extends StatelessWidget {
  const GroceriesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Groceries List'),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => GroceryListItem(
          groceryItem: groceryItems[index],
        ),
        itemCount: groceryItems.length,
      ),
    );
  }
}
