import 'package:shoping_list/data/categories.dart';
import 'package:shoping_list/models/grocery_item.dart';
import 'package:shoping_list/models/category.dart';

final groceryItems = [
  GroceryItem(
    id: 'a',
    name: 'Milk',
    quantity: 1,
    category: categories[Categories.dairy]!,
  ),
  GroceryItem(
    id: 'b',
    name: 'Bananas',
    quantity: 5,
    category: categories[Categories.fruit]!,
  ),
  GroceryItem(
    id: 'c',
    name: 'Chicken',
    quantity: 1,
    category: categories[Categories.meat]!,
  ),
];
