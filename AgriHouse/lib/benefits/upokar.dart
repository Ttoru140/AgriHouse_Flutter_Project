import 'package:flutter/material.dart';
import 'api_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ফল ও সবজির উপকারিতা',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor:
            Colors.lightGreen[50], // Light green background
      ),
      home: HomePage3(),
    );
  }
}

class HomePage3 extends StatefulWidget {
  const HomePage3({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage3> {
  late Future<List<Map<String, String>>> _fruitsAndVegetables;
  List<Map<String, String>> _filteredItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fruitsAndVegetables = ApiController().fetchFruitsAndVegetables();
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'ফল ও সবজির উপকারিতা',
            style: TextStyle(fontSize: 20), // Adjust font size if needed
          ),
        ),
        backgroundColor: Colors.green, // Set AppBar background color
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterItems,
              decoration: InputDecoration(
                hintText: 'অনুসন্ধান করুন...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.green),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: _fruitsAndVegetables,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('ত্রুটি: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('কোন তথ্য পাওয়া যায়নি.'));
          } else {
            final items = snapshot.data!;
            // Filter items based on search query
            _filteredItems = items
                .where((item) =>
                    item['name']!.contains(_searchQuery) ||
                    _searchQuery.isEmpty)
                .toList();

            return ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(
                      _filteredItems[index]['name']!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      // Navigate to the detail page when tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(item: _filteredItems[index]),
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
    );
  }
}

// Detail Page
// Detail Page
class DetailPage extends StatelessWidget {
  final Map<String, String> item;

  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(item['name']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ভিটামিন: ${item['vitamins']}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              'খনিজ উপাদান: ${item['minerals']}', // Added mineral information
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'উপকারিতা:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              item['benefits']!,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20.0),
            Text(
              'ক্ষতি: ${item['harmful']}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: const Text('ফিরে যান'),
            ),
          ],
        ),
      ),
    );
  }
}
