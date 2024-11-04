import 'package:flutter/material.dart';
import 'api_controller.dart';
import 'fungicide_model.dart';

void main() {
  runApp(FungicidesApp());
}

class FungicidesApp extends StatelessWidget {
  const FungicidesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ছত্রাক নাশক তালিকা',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
      home: FungicideList(),
    );
  }
}

class FungicideList extends StatefulWidget {
  const FungicideList({super.key});

  @override
  _FungicideListState createState() => _FungicideListState();
}

class _FungicideListState extends State<FungicideList> {
  final ApiController apiController = ApiController();
  List<Fungicide> filteredFungicides = [];

  @override
  void initState() {
    super.initState();
    _loadFungicides();
  }

  Future<void> _loadFungicides() async {
    await apiController.loadFungicides();
    setState(() {
      filteredFungicides = apiController.fungicides;
    });
  }

  void _filterFungicides(String query) {
    final filtered = apiController.fungicides.where((fungicide) {
      return fungicide.name.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      filteredFungicides = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('ছত্রাক নাশক তালিকা')),
        backgroundColor: Colors.green, // Set the background color to green
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterFungicides,
              decoration: const InputDecoration(
                hintText: '🔍ছত্রাক নাশক অনুসন্ধান করুন...',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredFungicides.length,
        itemBuilder: (context, index) {
          final fungicide = filteredFungicides[index];
          return Card(
            shape: const CircleBorder(),
            elevation: 4,
            margin: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FungicideDetail(fungicide),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  fungicide.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class FungicideDetail extends StatelessWidget {
  final Fungicide fungicide;

  const FungicideDetail(this.fungicide, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fungicide.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '💧 সক্রিয় উপাদান: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              fungicide.activeIngredient,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),
            const Text(
              '📌 ব্যবহার: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              fungicide.usage,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),
            const Text(
              '⏰ প্রয়োগের সময়: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              fungicide.applicationTime,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 15),
            const Text(
              '⚖️ প্রয়োগ মাত্রা: ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              fungicide.dosage,
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
