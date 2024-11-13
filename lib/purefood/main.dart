import 'package:flutter/material.dart';
import 'package:testimn/purefood/carbohydrates.dart';
import 'package:testimn/purefood/minarel.dart';
import 'package:testimn/purefood/vitamin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrition Elements',
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF8BC34A)),
      ),
      home: ElementsPage(),
    );
  }
}

class ElementsPage extends StatelessWidget {
  final List<String> elements = [
    'Vitamin',
    'Mineral',
    'Protein',
    'Carbohydrates'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nutrition Elements',
          style: TextStyle(color: Colors.white), // Set the text color
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4CAF50), // Set the AppBar background color
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: elements.map((element) {
            return GestureDetector(
              onTap: () {
                switch (element) {
                  case 'Vitamin':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VitaminsListPage()),
                    );
                    break;
                  case 'Mineral':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MineralsListPage()),
                    );
                    break;
                  case 'Protein':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VitaminsListPage()),
                    );
                    break;
                  case 'Carbohydrates':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CarbohydratesPage()),
                    );
                    break;
                }
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 199, 212, 22)
                          .withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                width: 100,
                height: 100,
                alignment: Alignment.center,
                child: Text(
                  element,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 139, 240, 16),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
