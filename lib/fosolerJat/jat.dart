import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriHouse App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CropListPage(),
    );
  }
}

class CropListPage extends StatefulWidget {
  @override
  _CropPageState createState() => _CropPageState();
}

class _CropPageState extends State<CropListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Map<String, dynamic> cropData;
  String searchText = '';

  // Function to load JSON data from the provided URL
  Future<void> loadData() async {
    final response = await http
        .get(Uri.parse('https://ttoru140.github.io/AgriHouse/data.json'));

    if (response.statusCode == 200) {
      setState(() {
        cropData = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
    _tabController =
        TabController(length: 2, vsync: this); // Two tabs: Fosol and Fruit
  }

  @override
  Widget build(BuildContext context) {
    if (cropData.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Crop Information')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('AgriHouse Crop Info'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'ফসল (Crops)'),
            Tab(text: 'ফল (Fruit)'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.green.shade400, width: 1.5),
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search crops...',
                  hintStyle: TextStyle(color: Colors.green.shade400),
                  prefixIcon: Icon(Icons.search, color: Colors.green.shade400),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Crop Tab (ফসল)
                ListView(
                  children: cropData['ফসল'].entries.map<Widget>((entry) {
                    return CropCategoryWidget(
                      category: entry.key,
                      cropData: entry.value,
                      searchText: searchText,
                    );
                  }).toList(),
                ),
                // Fruit Tab (ফল)
                ListView(
                  children: cropData['ফল'].entries.map<Widget>((entry) {
                    return CropCategoryWidget(
                      category: entry.key,
                      cropData: entry.value,
                      searchText: searchText,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CropCategoryWidget extends StatelessWidget {
  final String category;
  final List<dynamic> cropData;
  final String searchText;

  CropCategoryWidget({
    required this.category,
    required this.cropData,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    // Filter crops based on search text
    List<dynamic> filteredData = cropData.where((crop) {
      return crop['নাম']
          .toString()
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 3,
        child: ExpansionTile(
          backgroundColor: Colors.green[50],
          title: Text(
            category,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700),
          ),
          children: filteredData.map<Widget>((crop) {
            return ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              title: Text(
                crop['নাম'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.green.shade900,
                    fontWeight: FontWeight.w500),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.green[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      title: Text(crop['নাম'],
                          style: TextStyle(color: Colors.green.shade900)),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            'বর্ণনা: ${crop['বর্ণনা']}',
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'জীবনকাল: ${crop['জীবনকাল']}',
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'মৌসুম: ${crop['মৌসুম']}',
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'ফলন: ${crop['ফলন']}',
                            style: TextStyle(color: Colors.black87),
                          ),
                          SizedBox(height: 6),
                          Text(
                            'উপস্থিত দেশ: ${crop['উপস্থিত_দেশসমূহ'].join(', ')}',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: Text('Close',
                              style: TextStyle(color: Colors.green.shade700)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
