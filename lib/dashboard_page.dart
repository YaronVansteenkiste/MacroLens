import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  double totalCalories = 0;
  double totalProtein = 0;
  double totalCarbs = 0;
  double totalSodium = 0;
  double totalSugar = 0;

  @override
  void initState() {
    super.initState();
    _loadUserMeals();
  }

  Future<void> _loadUserMeals() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        List<dynamic> breakfastMeals = userDoc['breakfastMeals'] ?? [];
        List<dynamic> lunchMeals = userDoc['lunchMeals'] ?? [];
        List<dynamic> snackMeals = userDoc['snackMeals'] ?? [];
        List<dynamic> dinnerMeals = userDoc['dinnerMeals'] ?? [];

        setState(() {
          totalCalories = _calculateTotal(breakfastMeals, 'calories') +
                          _calculateTotal(lunchMeals, 'calories') +
                          _calculateTotal(snackMeals, 'calories') +
                          _calculateTotal(dinnerMeals, 'calories');
          totalProtein = _calculateTotal(breakfastMeals, 'protein') +
                         _calculateTotal(lunchMeals, 'protein') +
                         _calculateTotal(snackMeals, 'protein') +
                         _calculateTotal(dinnerMeals, 'protein');
          totalCarbs = _calculateTotal(breakfastMeals, 'carbs') +
                       _calculateTotal(lunchMeals, 'carbs') +
                       _calculateTotal(snackMeals, 'carbs') +
                       _calculateTotal(dinnerMeals, 'carbs');
          totalSodium = _calculateTotal(breakfastMeals, 'sodium') +
                        _calculateTotal(lunchMeals, 'sodium') +
                        _calculateTotal(snackMeals, 'sodium') +
                        _calculateTotal(dinnerMeals, 'sodium');
          totalSugar = _calculateTotal(breakfastMeals, 'sugar') +
                       _calculateTotal(lunchMeals, 'sugar') +
                       _calculateTotal(snackMeals, 'sugar') +
                       _calculateTotal(dinnerMeals, 'sugar');
        });
      }
    }
  }

  double _calculateTotal(List<dynamic> meals, String nutrient) {
    // ignore: avoid_types_as_parameter_names
    return meals.fold(0, (sum, meal) => sum + (meal[nutrient] ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Dashboard'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Daily Nutrition Summary',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildNutritionBubble('Total Calories', '$totalCalories kcal'),
                  _buildNutritionBubble('Protein', '$totalProtein g'),
                  _buildNutritionBubble('Carbs', '$totalCarbs g'),
                  _buildNutritionBubble('Sodium', '$totalSodium mg'),
                  _buildNutritionBubble('Sugar', '$totalSugar g'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionBubble(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[100],
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
