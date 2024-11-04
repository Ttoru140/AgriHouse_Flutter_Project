import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyAppCr());
}

class MyAppCr extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bangladesh Krishi Unnayan Bank Branches',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CityListPage(),
    );
  }
}

class CityListPage extends StatefulWidget {
  @override
  _CityListPageState createState() => _CityListPageState();
}

class _CityListPageState extends State<CityListPage> {
  Map<String, dynamic> branches = {};
  List<String> filteredBranches = [];
  bool isLoading = true;
  String searchQuery = '';

  Future<void> loadBranchData() async {
    final response = await http.get(
      Uri.parse('https://ttoru140.github.io/AgriHouse/branch.json'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        branches = data['Divisions'];
        filteredBranches =
            branches.keys.toList(); // Initialize filtered branches
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load branch data');
    }
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredBranches = branches.keys
          .where((division) =>
              division.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadBranchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BKB Branch Cities'),
        backgroundColor: Colors.green[700],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              onChanged: updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search divisions...',
                hintStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.white),
                ),
                filled: true,
                fillColor: Colors.green[600],
                suffixIcon: Icon(Icons.search, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[100]!, Colors.green[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListView.builder(
                itemCount: filteredBranches.length,
                itemBuilder: (context, index) {
                  final division = filteredBranches[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        division,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800]),
                      ),
                      trailing:
                          Icon(Icons.arrow_forward, color: Colors.green[700]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BranchListPage(
                              branches: branches[division],
                              divisionName: division,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class BranchListPage extends StatefulWidget {
  final List<dynamic> branches;
  final String divisionName;

  BranchListPage({required this.branches, required this.divisionName});

  @override
  _BranchListPageState createState() => _BranchListPageState();
}

class _BranchListPageState extends State<BranchListPage> {
  List<dynamic> filteredBranches = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    filteredBranches = widget.branches; // Initialize with all branches
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
      filteredBranches = widget.branches
          .where((branch) =>
              branch['branchName'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.divisionName} Branches'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[100]!, Colors.green[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            TextField(
              onChanged: updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Search branches...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.green),
                ),
                filled: true,
                fillColor: Colors.green[50],
                suffixIcon: Icon(Icons.search, color: Colors.green),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: filteredBranches.length,
                itemBuilder: (context, index) {
                  final branch = filteredBranches[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: Text(
                        branch['branchName'],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800]),
                      ),
                      trailing:
                          Icon(Icons.arrow_forward, color: Colors.green[700]),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                BranchDetailPage(branch: branch),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BranchDetailPage extends StatelessWidget {
  final Map<String, dynamic> branch;

  BranchDetailPage({required this.branch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${branch['branchName']} Branch Details'),
        backgroundColor: Colors.green[700],
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green[100]!, Colors.green[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              branch['branchName'],
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800]),
            ),
            SizedBox(height: 20),
            Text('Address:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(branch['address'], style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Phone:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(branch['phone'], style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
