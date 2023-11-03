import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shopping/widgets/widgets.dart';
import "package:http/http.dart" as http;

import 'package:flutter_shopping/data/categories.dart';
import 'package:flutter_shopping/models/models.dart';
import 'package:flutter_shopping/screens/screens.dart';

class GroceriesListScreen extends StatefulWidget {
  const GroceriesListScreen({super.key});

  @override
  State<GroceriesListScreen> createState() => _GroceriesListScreenState();
}

class _GroceriesListScreenState extends State<GroceriesListScreen> {
  List<GroceryItem> _groceryItems = [];
  late Future<List<GroceryItem>> _loadedItems;

  @override
  void initState() {
    _loadedItems = _getGroceryItems();
    super.initState();
  }

  Future<List<GroceryItem>> _getGroceryItems() async {
    final Uri url = Uri.https(
      "bulu-grocery-list-default-rtdb.europe-west1.firebasedatabase.app",
      "/grocery-items.json",
    );

    final http.Response response = await http.get(url);

    if (response.statusCode >= 400) {
      throw Exception('Failed to load grocery items');
    }

    if (response.body == "null") {
      return [];
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

    return loadedGroceryItems;
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

      if (response.statusCode >= 400) {}

      setState(() {
        _groceryItems.remove(groceryItem);
      });
    } catch (e) {
      setState(() {});
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
      body: FutureBuilder(
        future: _loadedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading();
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.hasData) {
            _groceryItems = snapshot.data as List<GroceryItem>;
          }

          if (snapshot.data!.isEmpty) {
            return const EmptyGroceryList();
          }

          return ListView.builder(
            itemBuilder: (context, index) => Dismissible(
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => _handleDeleteGroceryItem(
                _groceryItems[index],
              ),
              key: ValueKey(snapshot.data![index].id),
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
                groceryItem: snapshot.data![index],
              ),
            ),
            itemCount: snapshot.data!.length,
          );
        },
      ),
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
