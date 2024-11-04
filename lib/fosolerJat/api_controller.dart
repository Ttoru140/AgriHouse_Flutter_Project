// api_controller.dart

import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

class ApiController {
  // Fetch data from the JSON file
  Future<List<dynamic>> fetchCropData() async {
    final String response =
        await rootBundle.rootBundle.loadString('assets/fosol.json');
    final data = json.decode(response);
    return data['ফসলের_জাত'];
  }
}
