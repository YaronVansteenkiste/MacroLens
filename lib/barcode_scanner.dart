import 'package:flutter/material.dart';
import 'package:macro_lens/meal_info.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                    if (mounted) {
                      setState(() {
                        product =
                            productInfo['product_name'] ?? "No product name";

                        final nutriments = productInfo['nutriments'] ??
                            {}; 
                          
                        print(nutriments);

                        calories = nutriments['energy-kcal_100g']?.toString() ??
                            "No calories found per 100g";
                        protein = nutriments['proteins_100g']?.toString() ??
                            "No protein found per 100g";
                        carbs = nutriments['carbohydrates_100g']?.toString() ??
                            "No carbs found per 100g";
                        sugar = nutriments['sugars_100g']?.toString() ??
                            "No sugar found per 100g";
                        fat = nutriments['fat_100g']?.toString() ??
                            "No fat found per 100g";
                      });
                    }
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
            const SizedBox(
              height: 10,
            ),
            Text('Product: $product'),
            const SizedBox(
              height: 10,
            ),
            Text('Calories: $calories'),
            const SizedBox(
              height: 10,
            ),
            Text('Protein: $protein'),
            const SizedBox(
              height: 10,
            ),
            Text('Carbs: $carbs'),
            const SizedBox(
              height: 10,
            ),
            Text('Sugar: $sugar'),
            const SizedBox(
              height: 10,
            ),
            Text('Fat: $fat'),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
