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
      title: 'Bank Branches by District',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: DistrictListScreen(),
    );
  }
}

class DistrictListScreen extends StatefulWidget {
  @override
  _DistrictListScreenState createState() => _DistrictListScreenState();
}

class _DistrictListScreenState extends State<DistrictListScreen> {
  Map<String, dynamic> zones = {};

  @override
  void initState() {
    super.initState();
    fetchDistrictData();
  }

  Future<void> fetchDistrictData() async {
    final response = await http.get(
        Uri.parse('https://ttoru140.github.io/AgriHouse/RajshahiBranch.json'));

    if (response.statusCode == 200) {
      setState(() {
        zones = json.decode(response.body)['zones'];
      });
    } else {
      throw Exception('Failed to load district data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select District',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.green[700],
        elevation: 5,
      ),
      body: zones.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: zones.keys.length,
              itemBuilder: (context, index) {
                String districtName = zones.keys.elementAt(index);

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      districtName,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.green[700]),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BranchListByDistrict(
                              districtName: districtName,
                              branches: zones[districtName]),
                        ),
                      );
                    },
                    tileColor: Colors.green[50],
                  ),
                );
              },
            ),
    );
  }
}

class BranchListByDistrict extends StatefulWidget {
  final String districtName;
  final List<dynamic> branches;

  BranchListByDistrict({required this.districtName, required this.branches});

  @override
  _BranchListByDistrictState createState() => _BranchListByDistrictState();
}

class _BranchListByDistrictState extends State<BranchListByDistrict> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredBranches = [];

  @override
  void initState() {
    super.initState();
    _filteredBranches = widget.branches; // Initialize with all branches
    _searchController.addListener(_filterBranches);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterBranches);
    _searchController.dispose();
    super.dispose();
  }

  void _filterBranches() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredBranches = widget.branches.where((branch) {
        final branchName = branch['branchName'].toLowerCase();
        return branchName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.districtName} Branches',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.green[700],
        elevation: 5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search branches...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredBranches.isEmpty
                ? Center(child: Text("No branches found"))
                : ListView.builder(
                    itemCount: _filteredBranches.length,
                    itemBuilder: (context, index) {
                      final branch = _filteredBranches[index];
                      return Card(
                        elevation: 4,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          title: Text(
                            branch['branchName'],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700]),
                          ),
                          subtitle: Text(
                            branch['address'],
                            style: TextStyle(
                                fontSize: 16, color: Colors.green[600]),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BranchDetailPage(branch: branch),
                              ),
                            );
                          },
                          tileColor: Colors.green[50],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class BranchDetailPage extends StatelessWidget {
  final dynamic branch;

  BranchDetailPage({required this.branch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          branch['branchName'],
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.green[700],
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch['branchName'],
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green[700]),
                    SizedBox(width: 8),
                    Text(
                      branch['address'],
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.green[700]),
                    SizedBox(width: 8),
                    Text(
                      branch['telephone'] ?? 'N/A',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.email, color: Colors.green[700]),
                    SizedBox(width: 8),
                    Text(
                      branch['email'] ?? 'N/A',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
