import 'dart:convert';
import 'package:flutter/services.dart';
import 'fungicide_model.dart';

class ApiController {
  List<Fungicide> fungicides = [];

  Future<void> loadFungicides() async {
    final String response =
        await rootBundle.loadString('assets/fungicides.json');
    final List<dynamic> data = json.decode(response);

    fungicides = data.map((item) => Fungicide.fromJson(item)).toList();
  }
}
