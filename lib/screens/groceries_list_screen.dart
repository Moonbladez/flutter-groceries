import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;

import 'package:flutter_shopping/data/categories.dart';
import 'package:flutter_shopping/models/models.dart';
import 'package:flutter_shopping/screens/screens.dart';
import 'package:flutter_shopping/widgets/widgets.dart';

class GroceriesListScreen extends StatefulWidget {
  const GroceriesListScreen({super.key});

  @override
  State<GroceriesListScreen> createState() => _GroceriesListScreenState();
}

class _GroceriesListScreenState extends State<GroceriesListScreen> {
  List<GroceryItem> _groceryItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    _getGroceryItems();
    super.initState();
  }

  void _getGroceryItems() async {
    final Uri url = Uri.https(
      "bulu-grocery-list-default-rtdb.europe-west1.firebasedatabase.app",
      "/grocery-items.json",
    );

    final http.Response response = await http.get(url);
    final Map<String, dynamic> data = json.decode(response.body);

    final List<GroceryItem> loadedGroceryItems = [];

    for (final item in data.entries) {
      final categoryEntry = categories.entries.firstWhere(
        (cat) => cat.value.title == item.value['category'],
      );

      final Category category = categoryEntry.value;

      loadedGroceryItems.add(
        GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category,
        ),
      );
    }

    setState(() {
      _groceryItems = loadedGroceryItems;
      _isLoading = false;
    });
  }

  void _handleAddGroceryItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (context) => const AddGroceryItemScreen(),
      ),
    );

    if (newItem != null) {
      setState(() {
        _groceryItems.add(newItem);
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
    Widget body;
    if (_isLoading) {
      body = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_groceryItems.isNotEmpty) {
      body = ListView.builder(
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
      );
    } else {
      body = const EmptyGroceryList();
    }
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
      body: body,
    );
  }
}
