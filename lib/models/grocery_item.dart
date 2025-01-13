import 'package:shoping_list/models/category.dart';

enum GroceryItems{
  id,
  name,
  quantity,
  category,
}

class GroceryItem {
  const GroceryItem({ required this.id, required this.name, required this.quantity, required this.category});
  final String id;
  final String name;
  final int quantity;
  final Category category;
}