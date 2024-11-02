import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
  List<dynamic>? data;

  @override
  void initState() {
    super.initState();
    fetchJsonData();
  }

  Future<void> fetchJsonData() async {
    final response = await http
        .get(Uri.parse('https://ttoru140.github.io/AgriHouse/sobjicash.json'));

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
        title: Text('AgriHouse - সবজি তথ্য'),
      ),
      body: data == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: data!.length,
                itemBuilder: (context, index) {
                  return _buildVegetableCard(data![index]);
                },
              ),
            ),
    );
  }

  Widget _buildVegetableCard(Map<String, dynamic> vegetable) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('নাম: ${vegetable['নাম']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('বৈজ্ঞানিক নাম: ${vegetable['বৈজ্ঞানিক_নাম']}',
                style: TextStyle(fontSize: 16)),
            Text('মাটি প্রকার: ${vegetable['মাটি']['প্রকার'].join(', ')}',
                style: TextStyle(fontSize: 16)),
            Text('পিএইচ: ${vegetable['মাটি']['পিএইচ']}',
                style: TextStyle(fontSize: 16)),
            Text('মাটির প্রস্তুতি: ${vegetable['মাটি']['প্রস্তুতি']}',
                style: TextStyle(fontSize: 16)),
            Text('বাংলাদেশে জাত: ${vegetable['বাংলাদেশে_জাত']}',
                style: TextStyle(fontSize: 16)),
            Text('বীজের পরিমাণ: ${vegetable['বীজের_পরিমাণ']}',
                style: TextStyle(fontSize: 16)),
            Text('জল দেওয়া: ${vegetable['পরিচর্যা']['জল_দেওয়া']}',
                style: TextStyle(fontSize: 16)),
            Text('আগাছা পরিষ্কার: ${vegetable['পরিচর্যা']['আগাছা_পরিষ্কার']}',
                style: TextStyle(fontSize: 16)),
            Text('গাজর সংগ্রহ ফলন: ${vegetable['গাজর_সংগ্রহ']['ফলন']}',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
