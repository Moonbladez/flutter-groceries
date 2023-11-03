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
  String? _errorMessage;

  @override
  void initState() {
    _getGroceryItems();
    super.initState();
  }

  Future<void> _getGroceryItems() async {
    final Uri url = Uri.https(
      "bulu-grocery-list-default-rtdb.europe-west1.firebasedatabase.app",
      "/grocery-items.json",
    );

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode >= 400) {
        throw Exception('Failed to load grocery items');
      }

      if (response.body == "null") {
        setState(() {
          _isLoading = false;
        });
        return;
      }

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
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
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

  void _handleDeleteGroceryItem(GroceryItem groceryItem) async {
    final Uri url = Uri.https(
      "bulu-grocery-list-default-rtdb.europe-west1.firebasedatabase.app",
      "/grocery-items/${groceryItem.id}.json",
    );

    try {
      final response = await http.delete(url);

      if (response.statusCode >= 400) {
        _errorMessage = 'Failed to delete grocery item';
      }

      setState(() {
        _groceryItems.remove(groceryItem);
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
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
      body: _isLoading
          ? const Loading()
          : _errorMessage != null
              ? Error(errorMessage: _errorMessage)
              : _groceryItems.isNotEmpty
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
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
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

class Loading extends StatelessWidget {
  const Loading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
