import 'package:cloud_firestore/cloud_firestore.dart'; 
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:macro_lens/barcode_scanner.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<Map<String, dynamic>> breakfastMeals = [];
  List<Map<String, dynamic>> lunchMeals = [];
  List<Map<String, dynamic>> dinnerMeals = [];
  List<Map<String, dynamic>> snackMeals = [];
  late num caloriesGoal;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        breakfastMeals = List<Map<String, dynamic>>.from(userDoc['breakfastMeals'] ?? []);
        lunchMeals = List<Map<String, dynamic>>.from(userDoc['lunchMeals'] ?? []);
        dinnerMeals = List<Map<String, dynamic>>.from(userDoc['dinnerMeals'] ?? []);
        snackMeals = List<Map<String, dynamic>>.from(userDoc['snackMeals'] ?? []);
        caloriesGoal = userDoc['caloriesGoal'] ?? 2000;
        isLoading = false;
      });
    }
  }

  Future<void> _saveMeals() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'breakfastMeals': breakfastMeals,
        'lunchMeals': lunchMeals,
        'dinnerMeals': dinnerMeals,
        'snackMeals': snackMeals,
      });
    }
  }

  void _removeMeal(String mealType, int index) {
    setState(() {
      switch (mealType) {
        case 'Breakfast':
          breakfastMeals.removeAt(index);
          break;
        case 'Lunch':
          lunchMeals.removeAt(index);
          break;
        case 'Dinner':
          dinnerMeals.removeAt(index);
          break;
        case 'Snacks':
          snackMeals.removeAt(index);
          break;
      }
      _saveMeals();
    });
  }

  String _shortenMealName(String name) {
    return name.length > 12 ? '${name.substring(0, 12)}...' : name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView( 
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPieChart(),
                    const SizedBox(height: 16),
                    _buildMealSection(
                        'Breakfast', breakfastMeals, Icons.breakfast_dining),
                    _buildMealSection('Lunch', lunchMeals, Icons.lunch_dining),
                    _buildMealSection('Dinner', dinnerMeals, Icons.dinner_dining),
                    _buildMealSection('Snacks', snackMeals, Icons.fastfood),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BarcodeScanner(),
            ),
          );
          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              switch (result['mealType']) {
                case 'Breakfast':
                  breakfastMeals.add(result);
                  break;
                case 'Lunch':
                  lunchMeals.add(result);
                  break;
                case 'Dinner':
                  dinnerMeals.add(result);
                  break;
                case 'Snacks':
                  snackMeals.add(result);
                  break;
              }
              _saveMeals();
            });
          }
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildPieChart() {
    num totalCalories = 0;
    for (var meal in breakfastMeals) {
      totalCalories += meal['calories'] ?? 0;
    }
    for (var meal in lunchMeals) {
      totalCalories += meal['calories'] ?? 0;
    }
    for (var meal in dinnerMeals) {
      totalCalories += meal['calories'] ?? 0;
    }
    for (var meal in snackMeals) {
      totalCalories += meal['calories'] ?? 0;
    }
    
    
    num remainingCalories = caloriesGoal - totalCalories;

    return Card(
      color: const Color.fromARGB(255, 23, 35, 49),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                        value: (totalCalories / caloriesGoal * 100).roundToDouble(), color: Colors.blue, title: '${(totalCalories / caloriesGoal * 100).round()}%'),
                    PieChartSectionData(
                        value: ((caloriesGoal - totalCalories) / caloriesGoal * 100).roundToDouble(), color: const Color.fromARGB(255, 65, 59, 173), title: '${((caloriesGoal - totalCalories) / caloriesGoal * 100).round()}%'),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: remainingCalories.round().toString(),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 0, 122, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: ' remaining',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 12,
                            fontWeight: FontWeight.w100,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(8),
                    value: totalCalories / caloriesGoal,
                    backgroundColor: const Color.fromARGB(255, 21, 27, 35),
                    color: Colors.blueAccent,
                    minHeight: 10,
                  ),
                  const SizedBox(height: 8),
                  Text('${totalCalories.round()} of ${caloriesGoal.round()} calories',
                      style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSection(
      String title, List<Map<String, dynamic>> meals, IconData icon) {
    return Card(
      color: const Color.fromARGB(255, 23, 35, 49),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${_calculateTotalCalories(meals)} calories',
                    style: const TextStyle(color: Colors.white70)),
              ],
            ),
            for (var i = 0; i < meals.length; i++)
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_shortenMealName(meals[i]['name'])}: ${meals[i]['calories']} calories',
                        style: const TextStyle(color: Colors.white60, fontSize: 14)),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _removeMeal(title, i),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 4),
              child: GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BarcodeScanner(),
                    ),
                  );
                  if (result != null && result is Map<String, dynamic>) {
                    setState(() {
                      switch (title) {
                        case 'Breakfast':
                          breakfastMeals.add(result);
                          break;
                        case 'Lunch':
                          lunchMeals.add(result);
                          break;
                        case 'Dinner':
                          dinnerMeals.add(result);
                          break;
                        case 'Snacks':
                          snackMeals.add(result);
                          break;
                      }
                      _saveMeals();
                    });
                  }
                },
                child: const Text('ADD FOOD',
                    style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateTotalCalories(List<Map<String, dynamic>> meals) {
    // ignore: avoid_types_as_parameter_names
    return meals.fold(0, (sum, meal) => sum + (meal['calories'] as num).toInt());
  }
}