import 'package:flutter/material.dart';
import 'package:responsi023/mealpage.dart';
import 'mealpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meals',
      home: MealPage(),
    );
  }
}
