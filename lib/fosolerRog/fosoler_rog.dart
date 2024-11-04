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
      title: 'AgriHouse - ফসলের জাত',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: CropListPage4(),
    );
  }
}

class CropListPage4 extends StatefulWidget {
  const CropListPage4({super.key});

  @override
  _CropListPageState createState() => _CropListPageState();
}

class _CropListPageState extends State<CropListPage4> {
  List<dynamic> cropList = [];
  List<dynamic> filteredList = [];
  final ApiController apiController = ApiController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchCropData();
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  Future<void> fetchCropData() async {
    final data = await apiController.fetchCropData();
    setState(() {
      cropList = data['ফসলের_জাত'];
      filteredList = cropList;
    });
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredList = cropList;
      });
    } else {
      setState(() {
        filteredList = cropList.where((crop) {
          return crop['ফসলের_নাম']
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'ফসলের জাতের তালিকা',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 7, 255, 57),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Field
            TextField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: '🔍 Search ফসলের নাম',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20), // Spacing between search and list

            // Crop List Title
            const Text(
              'ফসলের তালিকা',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10), // Spacing

            // Crop List
            Expanded(
              child: ListView.builder(
                itemCount: filteredList.length,
                itemBuilder: (context, index) {
                  String cropName = filteredList[index]['ফসলের_নাম'];

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        cropName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward,
                        color: Colors.green,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CropDetailPage(crop: filteredList[index]),
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

class CropDetailPage extends StatelessWidget {
  final Map<String, dynamic> crop;

  const CropDetailPage({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    // Define an emoji based on the crop name
    final Map<String, String> cropEmojis = {
      'ধান': '🌾',
      'গম': '🌾',
      'আলু': '🥔',
      'পাট': '🌿',
      'মসুর': '🫛',
      'তিল': '🌾',
      'ভুট্টা': '🌽',
      'সরিষা': '🌱',
      'চালকুমড়া': '🎃',
      'টমেটো': '🍅',
      'পেঁপে': '🍈',
    };

    String cropName = crop['ফসলের_নাম'];
    String emoji = cropEmojis[cropName] ?? '🌱'; // Default emoji if not found

    return Scaffold(
      appBar: AppBar(
        title: Text(cropName),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 7, 255, 57),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Crop Emoji
                  Center(
                    child: Text(
                      emoji,
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Disease Title
                  const Text(
                    'রোগ:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${crop['রোগ']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  // Prevention Title
                  const Text(
                    'প্রতিরোধ:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${crop['প্রতিরোধ']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  // Remedy Title
                  const Text(
                    'প্রতিকার:',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${crop['প্রতিকার']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
