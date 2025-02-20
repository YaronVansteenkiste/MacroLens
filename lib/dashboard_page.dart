import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

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
            _buildNutritionCard('Total Calories', '2200 kcal'),
            _buildNutritionCard('Protein', '150g'),
            _buildNutritionCard('Carbs', '250g'),
            _buildNutritionCard('Sodium', '2300mg'),
            _buildNutritionCard('Sugar', '50g'),
            const SizedBox(height: 20),
            const Text(
              'Example Meals',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildMealCard('Breakfast', 'Oatmeal with berries & almonds'),
            _buildMealCard('Lunch', 'Grilled chicken with quinoa & veggies'),
            _buildMealCard('Dinner', 'Salmon with roasted potatoes & salad'),
            _buildMealCard('Snack', 'Greek yogurt with honey & nuts'),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionCard(String title, String value) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        trailing: Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
      ),
    );
  }

  Widget _buildMealCard(String mealType, String mealDescription) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(mealType, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        subtitle: Text(mealDescription, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
