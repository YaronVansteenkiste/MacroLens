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
  num caloriesGoal = 2000; 

  List<Map<String, dynamic>> breakfastMeals = [];
  List<Map<String, dynamic>> lunchMeals = [];
  List<Map<String, dynamic>> snackMeals = [];
  List<Map<String, dynamic>> dinnerMeals = [];

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
      DocumentSnapshot<Map<String, dynamic>> userDoc = 
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final data = userDoc.data();
        breakfastMeals = List<Map<String, dynamic>>.from(data?['breakfastMeals'] ?? []);
        lunchMeals = List<Map<String, dynamic>>.from(data?['lunchMeals'] ?? []);
        snackMeals = List<Map<String, dynamic>>.from(data?['snackMeals'] ?? []);
        dinnerMeals = List<Map<String, dynamic>>.from(data?['dinnerMeals'] ?? []);
        caloriesGoal = data?['caloriesGoal'] ?? 2000;

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

  double _calculateTotal(List<Map<String, dynamic>> meals, String nutrient) {
    return meals.fold<double>(
      0.0, 
      (sum, meal) => sum + ((meal[nutrient] ?? 0) as num).toDouble()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
              const SizedBox(height: 20),
              const Text(
                'Meal Summary',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildMealSummary(),
              const SizedBox(height: 20),
              const Text(
                'Progress Chart',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildProgressChart(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealSummary() {
    return Card(
      color: const Color.fromARGB(255, 23, 35, 49),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMealSection('Breakfast', Colors.orange),
            _buildMealSection('Lunch', Colors.green),
            _buildMealSection('Dinner', Colors.blue),
            _buildMealSection('Snacks', Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSection(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.fastfood, color: color),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(
            '${_calculateTotalCalories(title)} calories',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  int _calculateTotalCalories(String mealType) {
    switch (mealType) {
      case 'Breakfast':
        return totalCaloriesFromMeals(breakfastMeals);
      case 'Lunch':
        return totalCaloriesFromMeals(lunchMeals);
      case 'Dinner':
        return totalCaloriesFromMeals(dinnerMeals);
      case 'Snacks':
        return totalCaloriesFromMeals(snackMeals);
      default:
        return 0;
    }
  }

  int totalCaloriesFromMeals(List<Map<String, dynamic>> meals) {
    return meals.fold<int>(
      0, 
      (sum, meal) => sum + ((meal['calories'] ?? 0) as num).toInt()
    );
  }

  Widget _buildProgressChart() {
    return Card(
      color: const Color.fromARGB(255, 23, 35, 49),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Calories Progress',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: totalCalories / caloriesGoal,
              backgroundColor: const Color.fromARGB(255, 21, 27, 35),
              color: Colors.blueAccent,
              minHeight: 10,
            ),
            const SizedBox(height: 10),
            Text(
              '${totalCalories.round()} of $caloriesGoal calories',
              style: const TextStyle(color: Colors.white70),
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
        color: color.withAlpha(51),
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
