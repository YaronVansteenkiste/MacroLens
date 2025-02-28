import 'package:flutter/material.dart';

class FoodDetailPage extends StatefulWidget {
  final String product;
  final double calories;
  final double protein;
  final double carbs;
  final double sugar;
  final double fat;
  final String mealType;
  final bool isEditing;
  final int? index;

  const FoodDetailPage({
    super.key,
    required this.product,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.sugar,
    required this.fat,
    required this.mealType,
    this.isEditing = false,
    this.index,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FoodDetailPageState createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  double amount = 100.0;

  void _saveFood() {
    Navigator.pop(context, {
      'name': widget.product,
      'calories': double.parse((widget.calories * amount / 100).toStringAsFixed(1)),
      'protein': double.parse((widget.protein * amount / 100).toStringAsFixed(1)),
      'carbs': double.parse((widget.carbs * amount / 100).toStringAsFixed(1)),
      'sugar': double.parse((widget.sugar * amount / 100).toStringAsFixed(1)),
      'fat': double.parse((widget.fat * amount / 100).toStringAsFixed(1)),
      'mealType': widget.mealType,
      'isEditing': widget.isEditing,
      'index': widget.index,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.product,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('Enter weight (g):',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 10),
            SizedBox(
              width: 150,
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '100',
                ),
                onChanged: (value) {
                  setState(() {
                    amount = double.tryParse(value) ?? 100.0;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              color: const Color.fromARGB(255, 23, 35, 49),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(widget.product,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    _buildNutritionRow('Calories', widget.calories),
                    _buildNutritionRow('Protein', widget.protein),
                    _buildNutritionRow('Carbs', widget.carbs),
                    _buildNutritionRow('Sugar', widget.sugar),
                    _buildNutritionRow('Fat', widget.fat),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveFood,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            label == 'Calories'
                ? '${(value * amount / 100).toStringAsFixed(1)} kcal'
                : '${(value * amount / 100).toStringAsFixed(1)} g',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
