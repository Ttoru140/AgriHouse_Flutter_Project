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
      title: 'Bank Branches',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: BranchListScreen(),
    );
  }
}

class BranchListScreen extends StatefulWidget {
  @override
  _BranchListScreenState createState() => _BranchListScreenState();
}

class _BranchListScreenState extends State<BranchListScreen> {
  Map<String, dynamic> districts = {};
  List<String> districtList = [];
  List<String> filteredDistricts = [];

  @override
  void initState() {
    super.initState();
    fetchBranchData();
  }

  Future<void> fetchBranchData() async {
    final response = await http
        .get(Uri.parse('https://ttoru140.github.io/AgriHouse/branchReal.json'));

    if (response.statusCode == 200) {
      setState(() {
        districts = json.decode(response.body)['districts'];
        districtList = districts.keys.toList();
        filteredDistricts = districtList;
      });
    } else {
      throw Exception('Failed to load branch data');
    }
  }

  void filterDistricts(String query) {
    final filteredList = districtList.where((district) {
      return district.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredDistricts = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bank Branches',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.green[700],
        elevation: 5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) => filterDistricts(query),
              decoration: InputDecoration(
                labelText: 'Search District',
                hintText: 'Enter district name',
                prefixIcon: Icon(Icons.search, color: Colors.green[700]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredDistricts.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredDistricts.length,
                    itemBuilder: (context, index) {
                      final districtName = filteredDistricts[index];
                      final branches = districts[districtName] as List;

                      return Card(
                        elevation: 4,
                        margin:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          title: Text(
                            districtName,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.green[700]),
                          ),
                          onTap: () {
                            // Navigate to the branch list page for this district
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BranchDetailsPage(
                                    districtName: districtName,
                                    branches: branches),
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

class BranchDetailsPage extends StatefulWidget {
  final String districtName;
  final List<dynamic> branches;

  BranchDetailsPage({required this.districtName, required this.branches});

  @override
  _BranchDetailsPageState createState() => _BranchDetailsPageState();
}

class _BranchDetailsPageState extends State<BranchDetailsPage> {
  List<dynamic> filteredBranches = [];

  @override
  void initState() {
    super.initState();
    filteredBranches = widget.branches;
  }

  void filterBranches(String query) {
    final filteredList = widget.branches.where((branch) {
      return branch['branch_name'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredBranches = filteredList;
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
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) => filterBranches(query),
              decoration: InputDecoration(
                labelText: 'Search Branch',
                hintText: 'Enter branch name',
                prefixIcon: Icon(Icons.search, color: Colors.green[700]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.green[700]!, width: 2),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredBranches.isEmpty
                ? Center(child: Text('No branches found'))
                : ListView.builder(
                    itemCount: filteredBranches.length,
                    itemBuilder: (context, index) {
                      final branch = filteredBranches[index];

                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          title: Text(
                            branch['branch_name'],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            'PO: ${branch['address']['post_office']}',
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
          branch['branch_name'],
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
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.green[700]),
                    SizedBox(width: 8),
                    Text(
                      'Address: ${branch['address']['post_office']}, ${branch['address']['district']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.green[700]),
                    SizedBox(width: 8),
                    Text(
                      'Contact: ${branch['contact_number'] ?? branch['contact_numbers']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.email, color: Colors.green[700]),
                    SizedBox(width: 8),
                    Text(
                      'Email: ${branch['email']}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(thickness: 1, color: Colors.green[200]),
                SizedBox(height: 12),
                Text(
                  'Branch Details:',
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700]),
                ),
                SizedBox(height: 8),
                Text(
                  'Branch ID: ${branch['branch_id']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
