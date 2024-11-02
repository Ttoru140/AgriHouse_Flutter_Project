import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyAppPrivacy());
}

class MyAppPrivacy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Privacy Policy',
      theme: ThemeData(primarySwatch: Colors.green),
      home: PrivacyPolicyPage(),
    );
  }
}

class PrivacyPolicyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  List<dynamic> privacyPolicy = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadPrivacyPolicy();
  }

  Future<void> loadPrivacyPolicy() async {
    final response = await http
        .get(Uri.parse('https://ttoru140.github.io/AgriHouse/privacy.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        privacyPolicy = data['privacy_policy'];
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load privacy policy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.green[800],
        elevation: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[100]!, Colors.green[300]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: ListView.builder(
                  itemCount: privacyPolicy.length,
                  itemBuilder: (context, index) {
                    final section = privacyPolicy[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildFormattedText(section['title'], isTitle: true),
                            SizedBox(height: 12),
                            if (section['content'] is String)
                              buildFormattedText(section['content'])
                            else if (section['content'] is List)
                              ...section['content']
                                  .map<Widget>(
                                      (text) => buildFormattedText(text))
                                  .toList(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  // Helper function to format text with italics
  Widget buildFormattedText(String text, {bool isTitle = false}) {
    final spans = <TextSpan>[];
    final parts = text.split('*');

    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(
          text: parts[i],
          style: TextStyle(
            fontSize: isTitle ? 20 : 16,
            fontWeight: isTitle ? FontWeight.bold : FontWeight.normal,
            fontStyle: i % 2 != 0 ? FontStyle.italic : FontStyle.normal,
            color: Colors.green[900],
          ),
        ));
      }
    }

    return RichText(
      text: TextSpan(children: spans, style: TextStyle(color: Colors.black)),
    );
  }
}
