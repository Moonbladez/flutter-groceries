import 'package:flutter/material.dart';
import 'package:flutter_shopping/models/category.dart';

const categories = {
  Categories.vegetables: Category(
    title: 'Vegetables',
    color: Colors.green,
  ),
  Categories.fruit: Category(
    title: 'Fruit',
    color: Colors.orange,
  ),
  Categories.meat: Category(
    title: 'Meat',
    color: Colors.red,
  ),
  Categories.dairy: Category(
    title: 'Dairy',
    color: Colors.blue,
  ),
  Categories.carbs: Category(
    title: 'Carbs',
    color: Colors.purple,
  ),
  Categories.sweets: Category(
    title: 'Sweets',
    color: Colors.pink,
  ),
  Categories.spices: Category(
    title: 'Spices',
    color: Colors.yellow,
  ),
  Categories.convenience: Category(
    title: 'Convenience',
    color: Colors.teal,
  ),
  Categories.hygiene: Category(
    title: 'Hygiene',
    color: Colors.lightBlue,
  ),
  Categories.other: Category(
    title: 'Other',
    color: Colors.grey,
  ),
};
