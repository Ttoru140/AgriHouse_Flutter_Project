import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(SobjiCashApp());
}

class SobjiCashApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriHouse',
      theme: ThemeData(primarySwatch: Colors.green),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> vegetableNames = [
    'টমেটো',
    'বেগুন',
    'মুলা',
    'শিম',
    'গাজর',
    'আলু',
    'পেঁপে',
    'পালং',
    'মটর',
    'কপি',
  ];
  List<String> filteredNames = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredNames = vegetableNames;
  }

  void _filterSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredNames =
          vegetableNames.where((name) => name.contains(query)).toList();
    });
  }

  void _showVegetableDetails(BuildContext context, String vegetable) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VegetableDetailPage(vegetable: vegetable),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AgriHouse - সবজি তথ্য'),
        backgroundColor: Colors.green,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterSearch,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                prefixIcon: Icon(Icons.search, color: Colors.green),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[100]!, Colors.green[300]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView.builder(
          itemCount: filteredNames.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => _showVegetableDetails(context, filteredNames[index]),
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    filteredNames[index],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[800],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class VegetableDetailPage extends StatelessWidget {
  final String vegetable;

  VegetableDetailPage({required this.vegetable});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vegetable),
        backgroundColor: Colors.green, // Custom AppBar color
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchVegetableData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          } else {
            final data = snapshot.data!;
            final vegetableData = data['সবজি_চাষ'][vegetable + '_চাষ'];

            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[100]!, Colors.green[300]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ভূমিকা: ${vegetableData['ভূমিকা']}',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'মাটি:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800]),
                    ),
                    _buildDetailItem(
                        'মাটি প্রকার: ${vegetableData['মাটি']['মাটি_প্রকার']}'),
                    _buildDetailItem(
                        'পিএইচ: ${vegetableData['মাটি']['পিএইচ']}'),
                    _buildDetailItem(
                        'মাটির প্রস্তুতি: ${vegetableData['মাটি']['মাটির_প্রস্তুতি']}'),
                    SizedBox(height: 10),
                    Text(
                      'বীজ ও রোপণ:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800]),
                    ),
                    _buildDetailItem(
                        'বীজ নির্বাচন: ${vegetableData['বীজ_এবং_রোপণ']['বীজ_নির্বাচন']}'),
                    _buildDetailItem(
                        'রোপণের সময়: ${vegetableData['বীজ_এবং_রোপণ']['রোপণের_সময়']}'),
                    SizedBox(height: 10),
                    Text(
                      'জলসেচ:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800]),
                    ),
                    _buildDetailItem(
                        'প্রথম সেচ: ${vegetableData['জলসেচ']['প্রথম_সেচ']}'
                        'পরবর্তী_সেচ: ${vegetableData['জলসেচ']['পরবর্তী_সেচ']}'
                        'জল_নিষ্কাশন: ${vegetableData['জলসেচ']['জল_নিষ্কাশন']}'),
                    SizedBox(height: 10),
                    Text(
                      'সার প্রয়োগ:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800]),
                    ),
                    _buildDetailItem(
                        'জৈব সার: ${vegetableData['সার_প্রয়োগ']['জৈব_সার']}'),
                    SizedBox(height: 10),
                    Text(
                      'রোগ ও বালাই:',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800]),
                    ),
                    _buildDetailItem(
                        'পাতা কোকড়ানো রোগ: ${vegetableData['রোগবালাই']['পাতা_কোকড়ানো_রোগ']}'),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> fetchVegetableData() async {
    final response = await http
        .get(Uri.parse('https://ttoru140.github.io/AgriHouse/sobjicash.json'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Widget _buildDetailItem(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, color: Colors.black),
      ),
    );
  }
}
