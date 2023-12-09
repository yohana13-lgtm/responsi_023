import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'mealdetail.dart';

class MealCategoryPage extends StatefulWidget {
  final String category;

  MealCategoryPage({required this.category});

  @override
  _MealCategoryPageState createState() => _MealCategoryPageState();
}

class _MealCategoryPageState extends State<MealCategoryPage> {
  List<Map<String, dynamic>> meals = [];

  @override
  void initState() {
    super.initState();
    fetchMealsByCategory();
  }

  Future<void> fetchMealsByCategory() async {
    final apiUrl =
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category}';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null &&
            responseData['meals'] != null &&
            responseData['meals'] is List) {
          setState(() {
            meals = List<Map<String, dynamic>>.from(responseData['meals']);
          });
        } else {
          print('Error: No meals found');
        }
      } else {
        print('Error: Failed to fetch meals');
      }
    } catch (error) {
      print('Error fetching meals: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff80deea),
        centerTitle: true,
        title: Text('${widget.category} Meals'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: meals.length,
        itemBuilder: (context, index) {
          final meal = meals[index];
          return MealItem(mealData: meal);
        },
      ),
    );
  }
}

class MealItem extends StatelessWidget {
  final Map<String, dynamic> mealData;

  MealItem({required this.mealData});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealDetailPage(
                mealId: mealData['idMeal'],
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: mealData['strMealThumb'] != null
                  ? Image.network(
                mealData['strMealThumb'],
                fit: BoxFit.cover,
              )
                  : Container(
                color: Colors.grey,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                mealData['strMeal'] ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
