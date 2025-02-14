import 'package:flutter/material.dart';
import 'package:macro_lens/meal_info.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  String result = "No result";

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
                        result = productInfo['product_name'] ?? "No product name";
                      });
                    }
                  } catch (e) {
                    if (mounted) {
                      setState(() {
                        result = "Error: $e";
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
            Text('Scan Barcode Result: $result'),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
