import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getMealInfoFromBarcode(String barcode) async {
  final url = 'https://world.openfoodfacts.org/api/v0/product/$barcode.json';

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['product'] != null) {
        return data['product'];
      } else {
        throw Exception("No product found for this barcode.");
      }
    } else {
      throw Exception("Failed to load product info.");
    }
  } catch (e) {
    throw Exception("Error: $e");
  }
}
