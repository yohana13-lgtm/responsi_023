import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';


class MealDetailPage extends StatefulWidget {
  final String mealId;

  MealDetailPage({required this.mealId});

  @override
  _MealDetailPageState createState() => _MealDetailPageState();
}

class _MealDetailPageState extends State<MealDetailPage> {
  Map<String, dynamic> mealData = {};

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  Future<void> fetchMealDetails() async {
    final apiUrl =
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData != null &&
            responseData['meals'] != null &&
            responseData['meals'].isNotEmpty) {
          setState(() {
            mealData = responseData['meals'][0];
          });
        } else {
          print('Error: No meal details found');
        }
      } else {
        print('Error: Failed to fetch meal details');
      }
    } catch (error) {
      print('Error fetching meal details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff80deea),
        centerTitle: true,
        title: Text(mealData['strMeal'] ?? 'Meal Detail'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              mealData['strMealThumb'] ?? '',
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              'Category: ${mealData['strCategory'] ?? ''}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Area: ${mealData['strArea'] ?? ''}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Ingredients:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            // Display ingredients dynamically
            _buildIngredientsList(mealData),
            SizedBox(height: 20),
            Text(
              'Instructions:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              mealData['strInstructions'] ?? '',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _launchTutorial(mealData['strYoutube']);
              },
              child: Text('Watch Tutorial'),
            ),
          ],
        ),
      ),
    );
  }
  void _launchTutorial(String? youtubeLink) async {
    if (youtubeLink != null && await canLaunch(youtubeLink)) {
      await launch(youtubeLink);
    } else {
      throw 'Could not launch $youtubeLink';
    }
  }
  // Helper method to build ingredients list
  Widget _buildIngredientsList(Map<String, dynamic> mealData) {
    List<Widget> ingredientsWidgets = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = mealData['strIngredient$i'];
      final measure = mealData['strMeasure$i'];

      if (ingredient != null && ingredient.isNotEmpty) {
        ingredientsWidgets.add(
          Text(
            '- $ingredient: $measure',
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredientsWidgets,
    );
  }
}
