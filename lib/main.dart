import 'package:flutter/material.dart';
import 'package:shoping_list/widget/grocery_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Groceries',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,// font color
          surface: const Color.fromARGB(255, 42, 51, 59) // top bar color 
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255,50,58,60),// middle and bottom are colored
      ),
      home: const GroceryList(),
    );
  }
}
