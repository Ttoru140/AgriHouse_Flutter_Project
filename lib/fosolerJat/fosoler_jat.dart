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
      home: CropList(),
    );
  }
}

class CropList extends StatefulWidget {
  const CropList({super.key});

  @override
  _CropListPageState createState() => _CropListPageState();
}

class _CropListPageState extends State<CropList> {
  List<dynamic> cropList = [];
  List<dynamic> filteredList = [];
  final ApiController apiController = ApiController();
  TextEditingController searchController = TextEditingController();

  // Mapping of crop names to emojis
  final Map<String, String> cropEmojis = {
    'ধান': '🌾',
    'গম': '🌾',
    'ভুট্টা': '🌽',
    'সবজি': '🥬',
    'টমেটো': '🍅',
    'আলু': '🥔',
    'পাট': '🌿',
    'মসুর': '🫛',
    'পেঁপে': '🫑',
    // Add more crops and their corresponding emojis here
  };

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
      cropList = data; // Adjust based on your API response
      filteredList = data;
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
                  String emoji = cropEmojis[cropName] ??
                      '🌱'; // Default emoji if not found

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: Text(emoji,
                          style: const TextStyle(
                              fontSize: 28)), // Emoji as leading widget
                      title: Text(
                        cropName,
                        style: const TextStyle(fontSize: 20),
                      ),
                      subtitle: Text(filteredList[index]['জাতের_পরিচিত']),
                      trailing: const Icon(
                        Icons.arrow_forward,
                        color: Colors.green,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropDetailPage(
                              crop: filteredList[index],
                              cropEmojis: cropEmojis,
                            ),
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
  final Map<String, String> cropEmojis;

  const CropDetailPage(
      {super.key, required this.crop, required this.cropEmojis});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            crop['ফসলের_নাম'],
            style: const TextStyle(fontSize: 20),
          ),
        ),
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
                  // Crop Name with Emoji
                  Center(
                    child: Text(
                      cropEmojis[crop['ফসলের_নাম']] ?? '🌱', // Emoji
                      style: const TextStyle(fontSize: 60),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Display crop details
                  _buildDetailRow('পরিচিত:', crop['জাতের_পরিচিত']),
                  _buildDetailRow('জাতের বিবরণ:', crop['জাতের_বিবরণ']),
                  _buildDetailRow('জীবনকাল:', crop['জীবনকাল']),
                  _buildDetailRow('ফলন:', crop['ফলন']),
                  _buildDetailRow('সেচও আগাছা ব্যবস্থাপনা:',
                      crop['সেচও_আগাছা_ব্যবস্থাপনা']),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String? detail) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            detail ?? 'N/A', // Show N/A if detail is null
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
