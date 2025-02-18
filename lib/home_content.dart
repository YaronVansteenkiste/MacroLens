import 'package:flutter/material.dart';
import 'package:macro_lens/barcode_scanner.dart';
import 'package:fl_chart/fl_chart.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
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
            });
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildPieChart() {
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
                        value: 40, color: Colors.blue, title: '40%'),
                    PieChartSectionData(
                        value: 30, color: Colors.orange, title: '30%'),
                    PieChartSectionData(
                        value: 20, color: Colors.yellow, title: '20%'),
                    PieChartSectionData(
                        value: 10, color: Colors.green, title: '10%'),
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
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: '349 calories',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 122, 255),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
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
                    value: 2251 / 2600,
                    backgroundColor: const Color.fromARGB(255, 21, 27, 35),
                    color: Colors.blueAccent,
                    minHeight: 10,
                  ),
                  const SizedBox(height: 8),
                  Text('2251 of 2600 calories',
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
            for (var meal in meals)
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 4),
                child: Text('${meal['name']}: ${meal['calories']} calories',
                    style:
                        const TextStyle(color: Colors.white60, fontSize: 14)),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 4),
              child: GestureDetector(
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
            ),
          ],
        ),
      ),
    );
  }
}

int _calculateTotalCalories(List<Map<String, dynamic>> meals) {
  return meals.fold(0, (sum, meal) => sum + (meal['calories'] as num).toInt());
}
