import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MineralsApp());
}

class MineralsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minerals App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.lightGreen[50],
      ),
      home: MineralsListPage(),
    );
  }
}

class MineralsListPage extends StatefulWidget {
  @override
  _MineralsListPageState createState() => _MineralsListPageState();
}

class _MineralsListPageState extends State<MineralsListPage> {
  late Future<MineralsData> mineralsData;
  List<Mineral> allMinerals = [];
  List<Mineral> filteredMinerals = [];
  String searchText = '';

  Future<MineralsData> loadJsonData() async {
    final response = await http
        .get(Uri.parse('https://ttoru140.github.io/AgriHouse/minarel.json'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return MineralsData.fromJson(data);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    mineralsData = loadJsonData();
    mineralsData.then((data) {
      setState(() {
        allMinerals = data.minerals;
        filteredMinerals =
            allMinerals; // Initialize the filtered list with all minerals
      });
    });
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Mineral> results = allMinerals.where((mineral) {
        return mineral.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      setState(() {
        filteredMinerals = results;
      });
    } else {
      setState(() {
        filteredMinerals =
            allMinerals; // Reset to all minerals when query is empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minerals'),
        backgroundColor: Colors.green[800],
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
                hintText: 'Search by mineral name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<MineralsData>(
              future: mineralsData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || filteredMinerals.isEmpty) {
                  return Center(child: Text('No minerals found'));
                } else {
                  return ListView.builder(
                    itemCount: filteredMinerals.length,
                    itemBuilder: (context, index) {
                      final mineral = filteredMinerals[index];
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          title: Text(
                            mineral.name,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700]),
                          ),
                          trailing: Icon(Icons.arrow_forward,
                              color: Colors.green[600]),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MineralDetailPage(mineral: mineral),
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

class MineralDetailPage extends StatelessWidget {
  final Mineral mineral;

  const MineralDetailPage({Key? key, required this.mineral}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mineral.name),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          color: Colors.lightGreen[100],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sources:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900]),
              ),
              Text(
                mineral.sources.join(', '),
                style: TextStyle(fontSize: 16, color: Colors.green[800]),
              ),
              SizedBox(height: 16),
              Text(
                'Daily Requirement:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900]),
              ),
              Text(
                mineral.dailyRequirement.toString(),
                style: TextStyle(fontSize: 16, color: Colors.green[800]),
              ),
              SizedBox(height: 16),
              Text(
                'Benefits:',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[900]),
              ),
              for (var benefit in mineral.benefits)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(
                    '- $benefit',
                    style: TextStyle(fontSize: 16, color: Colors.green[800]),
                  ),
                ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Back to List'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
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

class MineralsData {
  List<Mineral> minerals;

  MineralsData({required this.minerals});

  factory MineralsData.fromJson(Map<String, dynamic> json) {
    var mineralsList = json['খনিজ পদার্থ'] as List;
    List<Mineral> minerals =
        mineralsList.map((i) => Mineral.fromJson(i)).toList();

    return MineralsData(minerals: minerals);
  }
}

class Mineral {
  String name;
  List<String> sources;
  Map<String, String> dailyRequirement;
  List<String> benefits;

  Mineral({
    required this.name,
    required this.sources,
    required this.dailyRequirement,
    required this.benefits,
  });

  factory Mineral.fromJson(Map<String, dynamic> json) {
    return Mineral(
      name: json['নাম'],
      sources: List<String>.from(json['উৎস']),
      dailyRequirement:
          Map<String, String>.from(json['প্রয়োজনীয় দৈনিক পরিমাণ']),
      benefits: List<String>.from(json['উপকারিতা']),
    );
  }
}
