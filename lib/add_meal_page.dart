import 'package:flutter/material.dart';

class AddMealPage extends StatelessWidget {
  const AddMealPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Recently Added Meals",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // List of recently added meals
            SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: 5, 
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.fastfood, color: Colors.white),
                      ),
                      title: Text("Meal #$index"),
                      subtitle: Text("Added just now"),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Scan barcode button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  print("TODO: Scanner function");
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Scan Meal Barcode"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blue, 
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
