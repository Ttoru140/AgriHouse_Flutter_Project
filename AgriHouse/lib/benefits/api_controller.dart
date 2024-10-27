import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ApiController {
  Future<List<Map<String, String>>> fetchFruitsAndVegetables() async {
    // Load the JSON file from assets
    final String response =
        await rootBundle.loadString('assets/fruits_and_vegetables.json');
    print('Response: $response'); // Log the response

    final List<dynamic> data = json.decode(response);
    return List<Map<String, String>>.from(
        data.map((item) => Map<String, String>.from(item)));
  }
}
