import 'package:flutter/material.dart';
import 'package:flutter_shopping/models/grocery_item.dart';
import 'package:flutter_shopping/screens/screens.dart';
import 'package:flutter_shopping/widgets/widgets.dart';

class GroceriesListScreen extends StatefulWidget {
  const GroceriesListScreen({super.key});

  @override
  State<GroceriesListScreen> createState() => _GroceriesListScreenState();
}

class _GroceriesListScreenState extends State<GroceriesListScreen> {
  final List<GroceryItem> _groceryItems = [];

  void _handleAddGroceryItem() async {
    final newGroceryItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const AddGroceryItemScreen(),
      ),
    );

    if (newGroceryItem != null) {
      setState(() {
        _groceryItems.add(newGroceryItem);
      });
    }
  }

  void _handleDeleteGroceryItem(GroceryItem groceryItem) {
    setState(() {
      _groceryItems.remove(groceryItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: _handleAddGroceryItem,
            icon: const Icon(Icons.add),
          ),
        ],
        title: const Text('Groceries List'),
      ),
      body: _groceryItems.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) => Dismissible(
                direction: DismissDirection.endToStart,
                onDismissed: (direction) => _handleDeleteGroceryItem(
                  _groceryItems[index],
                ),
                key: ValueKey(_groceryItems[index].id),
                background: Container(
                  color: Theme.of(context).colorScheme.errorContainer,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
                child: GroceryListItem(
                  groceryItem: _groceryItems[index],
                ),
              ),
              itemCount: _groceryItems.length,
            )
          : const EmptyGroceryList(),
    );
  }
}
