// api_controller.dart

import 'dart:convert';
import 'package:flutter/services.dart';

class ApiController {
  Future<Map<String, dynamic>> fetchCropData() async {
    // Load the local JSON file
    final String response = await rootBundle.loadString('assets/rog.json');
    return json.decode(response);
  }
}
