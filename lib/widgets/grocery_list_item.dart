import 'package:flutter/material.dart';
import 'package:flutter_shopping/models/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem({super.key, required this.groceryItem});

  final GroceryItem groceryItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.folder,
        color: groceryItem.category.color,
      ),
      title: Text(groceryItem.name),
      trailing: Text(
        '${groceryItem.quantity}',
      ),
    );
  }
}
