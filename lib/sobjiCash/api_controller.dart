import 'dart:convert';
import 'package:flutter/services.dart'; // For rootBundle

class ApiController {
  Future<List<dynamic>> loadSobjiData() async {
    try {
      // Load the JSON file from the assets
      String jsonString = await rootBundle.loadString('assets/sobjiCash.json');
      // Decode the JSON string and access the "চাষ" key
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return jsonMap["চাষ"] ??
          []; // Return the "চাষ" list or an empty list if null
    } catch (e) {
      // Handle any errors that might occur during loading or decoding
      print('Error loading Sobji data: $e');
      return []; // Return an empty list if there's an error
    }
  }
}
