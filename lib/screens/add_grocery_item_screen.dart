import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_shopping/data/categories.dart';
import 'package:flutter_shopping/models/models.dart';
import "package:http/http.dart" as http;

class AddGroceryItemScreen extends StatefulWidget {
  const AddGroceryItemScreen({super.key});

  @override
  State<AddGroceryItemScreen> createState() => _AddGroceryItemScreenState();
}

class _AddGroceryItemScreenState extends State<AddGroceryItemScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _enteredName = '';
  int _enteredQuantity = 1;
  Category _selectedCategory = categories[Categories.other] as Category;
  bool _isSubmitting = false;

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      _formKey.currentState!.save();
      final Uri url = Uri.https(
        "bulu-grocery-list-default-rtdb.europe-west1.firebasedatabase.app",
        "/grocery-items.json",
      );
      final http.Response response = await http.post(
        url,
        body: json.encode(
          {
            "name": _enteredName,
            "quantity": _enteredQuantity,
            "category": _selectedCategory.title,
          },
        ),
      );
      final Map<String, dynamic> data = json.decode(response.body);
      if (!context.mounted) return;

      Navigator.of(context).pop(
        GroceryItem(
          id: data["name"],
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectedCategory,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Grocery Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
                autofocus: true,
                maxLength: 50,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Name must be between 2 and 50 characters long';
                  }

                  return null;
                },
                onSaved: (newValue) => _enteredName = newValue!,
                initialValue: _enteredName,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                      ),
                      initialValue: _enteredQuantity.toString(),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.parse(value) < 0) {
                          return 'Quantity must be a positive number';
                        }
                        return null;
                      },
                      onSaved: (newValue) =>
                          _enteredQuantity = int.parse(newValue!),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      isDense: true,
                      value: _selectedCategory,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.folder,
                                  color: category.value.color,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(category.value.title)
                              ],
                            ),
                          ),
                      ],
                      onChanged: (newValue) {
                        setState(() {
                          _selectedCategory = newValue as Category;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      _isSubmitting ? null : _formKey.currentState!.reset();
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: const Text(
                      'Reset',
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    child: _isSubmitting
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                            ),
                          )
                        : const Text('Submit'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
