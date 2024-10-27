import 'dart:convert';
import 'package:flutter/services.dart';

class ApiController {
  Future<Map<String, dynamic>> fetchCropData() async {
    try {
      // Load JSON data from assets
      final String response = await rootBundle.loadString('assets/poka.json');
      // Decode JSON data
      final Map<String, dynamic> data = json.decode(response);
      return data;
    } catch (e) {
      print('Error fetching crop data: $e');
      return {};
    }
  }
}
