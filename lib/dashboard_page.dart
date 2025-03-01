import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  double totalCalories = 0;
  double totalProtein = 0;
  double totalCarbs = 0;
  double totalSodium = 0;
  double totalSugar = 0;
  double totalFat = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoScroll();
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
          totalFat = _calculateTotal(breakfastMeals, 'fat') +
                     _calculateTotal(lunchMeals, 'fat') +
                     _calculateTotal(snackMeals, 'fat') +
                     _calculateTotal(dinnerMeals, 'fat');
        });
      }
    }
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 2), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 10),
          curve: Curves.linear,
        ).then((_) {
          _scrollController.jumpTo(_scrollController.position.minScrollExtent);
          _startAutoScroll();
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  double _calculateTotal(List<dynamic> meals, String nutrient) {
    return meals.fold(0, (sum, meal) => sum + (meal[nutrient] ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  final nutritionIndex = index % 6;
                  switch (nutritionIndex) {
                    case 0:
                      return _buildNutritionBubble('Total Calories', '$totalCalories kcal', Colors.red);
                    case 1:
                      return _buildNutritionBubble('Protein', '$totalProtein g', Colors.green);
                    case 2:
                      return _buildNutritionBubble('Carbs', '$totalCarbs g', Colors.orange);
                    case 3:
                      return _buildNutritionBubble('Sodium', '$totalSodium mg', Colors.blue);
                    case 4:
                      return _buildNutritionBubble('Sugar', '$totalSugar g', Colors.purple);
                    case 5:
                      return _buildNutritionBubble('Fat', '$totalFat g', Colors.brown);
                    default:
                      return Container();
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 4, 
                itemBuilder: (context, index) {
                  return Container(
                    width: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/images/meal_$index.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionBubble(String title, String value, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: 100,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}