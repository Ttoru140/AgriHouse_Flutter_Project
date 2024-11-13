import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(VitaminsApp());
}

class VitaminsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vitamins App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.lightBlue[50],
      ),
      home: VitaminsListPage(),
    );
  }
}

class VitaminsListPage extends StatefulWidget {
  @override
  _VitaminsListPageState createState() => _VitaminsListPageState();
}

class _VitaminsListPageState extends State<VitaminsListPage> {
  late Future<VitaminsData> vitaminsData;
  List<Vitamin> allVitamins = [];
  List<Vitamin> filteredVitamins = [];
  String searchText = '';

  Future<VitaminsData> loadJsonData() async {
    final response = await http
        .get(Uri.parse('https://ttoru140.github.io/AgriHouse/vitamin.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return VitaminsData.fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    vitaminsData = loadJsonData();
    vitaminsData.then((data) {
      setState(() {
        allVitamins = data.vitamins;
        filteredVitamins =
            allVitamins; // Initialize the filtered list with all vitamins
      });
    });
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Vitamin> results = allVitamins.where((vitamin) {
        return vitamin.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      setState(() {
        filteredVitamins = results;
      });
    } else {
      setState(() {
        filteredVitamins =
            allVitamins; // Reset to all vitamins when query is empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vitamins'),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search by vitamin name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<VitaminsData>(
              future: vitaminsData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || filteredVitamins.isEmpty) {
                  return Center(child: Text('No vitamins found'));
                } else {
                  return ListView.builder(
                    itemCount: filteredVitamins.length,
                    itemBuilder: (context, index) {
                      final vitamin = filteredVitamins[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            vitamin.name,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700]),
                          ),
                          trailing: Icon(Icons.arrow_forward,
                              color: Colors.blue[600]),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VitaminDetailPage(vitamin: vitamin),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class VitaminDetailPage extends StatelessWidget {
  final Vitamin vitamin;

  const VitaminDetailPage({Key? key, required this.vitamin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(vitamin.name),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.lightBlue[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sources:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
              ),
              Text(
                vitamin.sources.join(', '),
                style: TextStyle(fontSize: 16, color: Colors.blue[800]),
              ),
              SizedBox(height: 16),
              Text(
                'Daily Requirement:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
              ),
              for (var key in vitamin.dailyRequirement.keys)
                Text(
                  '$key: ${vitamin.dailyRequirement[key]}',
                  style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                ),
              SizedBox(height: 16),
              Text(
                'Benefits:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900]),
              ),
              for (var benefit in vitamin.benefits)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    '- $benefit',
                    style: TextStyle(fontSize: 16, color: Colors.blue[800]),
                  ),
                ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back to List'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VitaminsData {
  List<Vitamin> vitamins;

  VitaminsData({required this.vitamins});

  factory VitaminsData.fromJson(Map<String, dynamic> json) {
    var vitaminsList = json['ভিটামিন'] as List;
    List<Vitamin> vitamins =
        vitaminsList.map((i) => Vitamin.fromJson(i)).toList();

    return VitaminsData(vitamins: vitamins);
  }
}

class Vitamin {
  String name;
  List<String> sources;
  Map<String, dynamic> dailyRequirement;
  List<String> benefits;

  Vitamin({
    required this.name,
    required this.sources,
    required this.dailyRequirement,
    required this.benefits,
  });

  factory Vitamin.fromJson(Map<String, dynamic> json) {
    return Vitamin(
      name: json['নাম'],
      sources: List<String>.from(json['উৎস']),
      dailyRequirement: json['প্রয়োজনীয় দৈনিক পরিমাণ'],
      benefits: List<String>.from(json['উপকারিতা']),
    );
  }
}
