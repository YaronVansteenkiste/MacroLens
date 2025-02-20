import 'package:flutter/material.dart';
import 'package:macro_lens/meal_info.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:macro_lens/food_detail_page.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  String product = "No result";
  String calories = "No result";
  String protein = "No result";
  String carbs = "No result";
  String sugar = "No result";
  String fat = "No result";

  final List<String> mealTypes = ["Breakfast", "Lunch", "Dinner", "Snacks"];
  String selectedMealType = "Breakfast"; // Default meal type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 10,
              children: mealTypes.map((meal) {
                return ChoiceChip(
                  label: Text(meal),
                  selected: selectedMealType == meal,
                  selectedColor: Colors.blueAccent,
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: selectedMealType == meal ? Colors.white : Colors.black,
                  ),
                  onSelected: (bool selected) {
                    setState(() {
                      selectedMealType = meal;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!mounted) return;

                String? barcode = await SimpleBarcodeScanner.scanBarcode(
                  context,
                  barcodeAppBar: const BarcodeAppBar(
                    appBarTitle: 'Test',
                    centerTitle: false,
                    enableBackButton: true,
                    backButtonIcon: Icon(Icons.arrow_back_ios),
                  ),
                  isShowFlashIcon: true,
                  delayMillis: 500,
                  cameraFace: CameraFace.back,
                  scanFormat: ScanFormat.ONLY_BARCODE,
                );

                if (barcode != null && barcode.isNotEmpty) {
                  try {
                    Map<String, dynamic> productInfo =
                        await getMealInfoFromBarcode(barcode);

                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      if (mounted) {
                        setState(() {
                          product = productInfo['product_name'] ?? "No product name";
                          final nutriments = productInfo['nutriments'] ?? {};
                          calories = nutriments['energy-kcal_100g']?.toString() ?? "No calories found per 100g";
                          protein = nutriments['proteins_100g']?.toString() ?? "No protein found per 100g";
                          carbs = nutriments['carbohydrates_100g']?.toString() ?? "No carbs found per 100g";
                          sugar = nutriments['sugars_100g']?.toString() ?? "No sugar found per 100g";
                          fat = nutriments['fat_100g']?.toString() ?? "No fat found per 100g";
                        });

                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FoodDetailPage(
                              product: product,
                              calories: double.tryParse(calories) ?? 0.0,
                              protein: double.tryParse(protein) ?? 0.0,
                              carbs: double.tryParse(carbs) ?? 0.0,
                              sugar: double.tryParse(sugar) ?? 0.0,
                              fat: double.tryParse(fat) ?? 0.0,
                              mealType: selectedMealType,
                            ),
                          ),
                        );

                        if (result != null && mounted) {
                          Navigator.pop(context, result);
                        }
                      }
                    });
                  } catch (e) {
                    if (mounted) {
                      setState(() {
                        product = "Error: $e";
                      });
                    }
                  }
                }
              },
              child: const Text('Scan Barcode'),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
