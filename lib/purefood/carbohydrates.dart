import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbohydrates Information',
      theme: ThemeData(
        primaryColor: Color(0xFF4CAF50), // Lighter green for accents
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.black87),
        ),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Color(0xFF8BC34A)),
      ),
      home: CarbohydratesPage(),
    );
  }
}

class CarbohydratesPage extends StatefulWidget {
  @override
  _CarbohydratesPageState createState() => _CarbohydratesPageState();
}

class _CarbohydratesPageState extends State<CarbohydratesPage> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(
        Uri.parse('https://ttoru140.github.io/AgriHouse/Carbohydrates.json'));

    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carbohydrates Information'),
        centerTitle: true,
        elevation: 6,
        backgroundColor: Color(0xFF388E3C), // Darker green for AppBar
      ),
      body: data == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  buildComplexCarbohydrates(),
                  SizedBox(height: 16),
                  buildSimpleCarbohydrates(),
                ],
              ),
            ),
    );
  }

  Widget buildComplexCarbohydrates() {
    final complexCarbohydrates =
        data!['carbohydrates']['complex_carbohydrates'] as List;

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(
          'Complex Carbohydrates',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50)),
        ),
        children: complexCarbohydrates.map((item) {
          return Card(
            margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              title: Text(
                item['name'],
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
              ),
              subtitle: Text(item['description'],
                  style: TextStyle(color: Colors.black54)),
              isThreeLine: true,
              onTap: () => showDetails(item),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildSimpleCarbohydrates() {
    final simpleCarbohydrates = data!['carbohydrates']['simple_carbohydrates'];

    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ExpansionTile(
        title: Text(
          'Simple Carbohydrates',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50)),
        ),
        children: [
          buildMonosaccharides(simpleCarbohydrates['monosaccharides']),
          buildDisaccharides(simpleCarbohydrates['disaccharides']),
        ],
      ),
    );
  }

  Widget buildMonosaccharides(List<dynamic> monosaccharides) {
    return ExpansionTile(
      title: Text(
        'Monosaccharides',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF388E3C)),
      ),
      children: monosaccharides.map((item) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            title: Text(
              item['name'],
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF388E3C)),
            ),
            subtitle: Text(item['description'] ?? 'No description available',
                style: TextStyle(color: Colors.black54)),
            isThreeLine: true,
            onTap: () => showDetails(item),
          ),
        );
      }).toList(),
    );
  }

  Widget buildDisaccharides(List<dynamic> disaccharides) {
    return ExpansionTile(
      title: Text(
        'Disaccharides',
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF388E3C)),
      ),
      children: disaccharides.map((item) {
        return Card(
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            title: Text(
              item['name'],
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF388E3C)),
            ),
            subtitle: Text(item['description'] ?? 'No description available',
                style: TextStyle(color: Colors.black54)),
            isThreeLine: true,
            onTap: () => showDetails(item),
          ),
        );
      }).toList(),
    );
  }

  void showDetails(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item['name'], style: TextStyle(color: Color(0xFF4CAF50))),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Description: ${item['description'] ?? 'N/A'}'),
                SizedBox(height: 10),
                Text('Sources:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text(item['sources'].join(', ')),
                SizedBox(height: 10),
                Text('Benefits:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...item['benefits']
                    .map((benefit) => Text('• $benefit'))
                    .toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
