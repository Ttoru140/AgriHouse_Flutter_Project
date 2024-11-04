// main.dart
import 'package:flutter/material.dart';
import 'zakat_info_page.dart'; // Import the Zakat Info Page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zakat App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ZakatInfoPage(),
    );
  }
}
