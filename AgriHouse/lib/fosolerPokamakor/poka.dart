import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
      home: CropListPage2(),
    );
  }
}

class CropListPage2 extends StatefulWidget {
  const CropListPage2({super.key});

  @override
  _CropListPageState createState() => _CropListPageState();
}

class _CropListPageState extends State<CropListPage2> {
  List<dynamic> cropList = [];
  List<dynamic> filteredList = [];
  TextEditingController searchController = TextEditingController();

  // Embedding JSON data directly into the code
  final List<dynamic> cropsData = [
    {
      "ফসলের_নাম": "ধান",
      "রোগের নাম": [
        {
          "নাম": "হলুদ মাথা মাজরা পোকা",
          "লিঙ্ক": "http://example.com/yellow_head_moth",
          "ছবি": "https://i.postimg.cc/W3hXsCCs/images.jpg"
        },
        {
          "নাম": "পাতা মড়ানো পোকা",
          "লিঙ্ক": "http://example.com/leaffolder",
          "ছবি": "https://i.postimg.cc/W3hXsCCs/images.jpg"
        },
        {
          "নাম": "বাদামী গাছ ফড়িং",
          "লিঙ্ক": "http://example.com/brown_plant_hopper",
          "ছবি": "https://i.postimg.cc/W3hXsCCs/images.jpg"
        },
        {
          "নাম": "ধানের গল্মাছি",
          "লিঙ্ক": "http://example.com/rice_stem_borer",
          "ছবি": "https://i.postimg.cc/W3hXsCCs/images.jpg"
        },
        {
          "নাম": "সবুজ পাতা ফড়িং",
          "লিঙ্ক": "http://example.com/green_plant_hopper",
          "ছবি": "https://i.postimg.cc/W3hXsCCs/images.jpg"
        },
        {
          "নাম": "ধানের গান্ধী পকা",
          "লিঙ্ক": "http://example.com/rice_gandhi_bug",
          "ছবি": "https://i.postimg.cc/W3hXsCCs/images.jpg"
        },
        {
          "নাম": "ধানের পাম্রী পোকা",
          "লিঙ্ক": "http://example.com/rice_leaf_miner",
          "ছবি": "https://i.postimg.cc/W3hXsCCs/images.jpg"
        },
        {
          "নাম": "ধানের পাতা মাছি",
          "লিঙ্ক": "http://example.com/rice_leaf_fly",
          "ছবি": "https://i.postimg.cc/W3hXsCCs/images.jpg"
        },
        {
          "নাম": "থানের থ্রিপ্স পোকা",
          "লিঙ্ক": "http://example.com/thrips",
          "ছবি": "https://i.postimg.cc/W3hXsCCs/images.jpg"
        }
      ],
    },
    {
      "ফসলের_নাম": "গম",
      "রোগের নাম": [
        {
          "নাম": "গমের মাজ্রা পোকা",
          "লিঙ্ক": "http://example.com/wheat_stem_borer",
          "ছবি": "https://i.postimg.cc/qML77k5x/download.jpg"
        },
        {
          "নাম": "জমের জাব পোকা",
          "লিঙ্ক": "http://example.com/jum_jab",
          "ছবি": "https://i.postimg.cc/qML77k5x/download.jpg"
        },
        {
          "নাম": "গমের স্টিং পোকা",
          "লিঙ্ক": "http://example.com/wheat_sting",
          "ছবি": "https://i.postimg.cc/qML77k5x/download.jpg"
        }
      ],
    },
    {
      "ফসলের_নাম": "ভুট্টা",
      "রোগের নাম": [
        {
          "নাম": "ভুট্টার ফল আর্মি ওয়ারম",
          "লিঙ্ক": "http://example.com/corn_army_worm",
          "ছবি": "https://i.postimg.cc/Z9tBtWXB/download-2.jpg"
        },
        {
          "নাম": "জাবপোকা",
          "লিঙ্ক": "http://example.com/jab_poka",
          "ছবি": "https://i.postimg.cc/Z9tBtWXB/download-2.jpg"
        },
        {
          "নাম": "পাতা মড়ানো পকা",
          "লিঙ্ক": "http://example.com/leaffolder_corn",
          "ছবি": "https://i.postimg.cc/Z9tBtWXB/download-2.jpg"
        },
        {
          "নাম": "মাজ্রা পোকা",
          "লিঙ্ক": "http://example.com/corn_stem_borer",
          "ছবি": "https://i.postimg.cc/Z9tBtWXB/download-2.jpg"
        },
        {
          "নাম": "টমেটো সাদা মাছি",
          "লিঙ্ক": "http://example.com/tomato_white_fly",
          "ছবি": "https://i.postimg.cc/Z9tBtWXB/download-2.jpg"
        },
        {
          "নাম": "ফল ছিদ্রকারী",
          "লিঙ্ক": "http://example.com/fruit_borer",
          "ছবি": "https://i.postimg.cc/Z9tBtWXB/download-2.jpg"
        },
        {
          "নাম": "পাতা সুরুংকারী",
          "লিঙ্ক": "http://example.com/leaf_cutter",
          "ছবি": "https://i.postimg.cc/Z9tBtWXB/download-2.jpg"
        }
      ],
    },
    {
      "ফসলের_নাম": "আলু",
      "রোগের নাম": [
        {
          "নাম": "আলুর জাব পোকা",
          "লিঙ্ক": "http://example.com/potato_borer",
          "ছবি": "https://i.postimg.cc/Z9tBtWXB/download-2.jpg"
        },
        {
          "নাম": "আলুর কাটুই পোকা",
          "লিঙ্ক": "http://example.com/potato_cutworm",
          "ছবি": "https://i.postimg.cc/Z9tBtWXB/download-2.jpg"
        },
        {
          "নাম": "আলুর সুরুঙ্গোপোকা",
          "লিঙ্ক": "http://example.com/potato_wireworm",
          "ছবি": "https://i.postimg.cc/Z9tBtWXB/download-2.jpg"
        },
        {
          "নাম": "ফ্লি বিটল",
          "লিঙ্ক": "http://example.com/flea_beetle",
          "ছবি": "https://i.postimg.cc/Z9tBtWXB/download-2.jpg"
        }
      ],
    },
    {
      "ফসলের_নাম": "পাট",
      "রোগের নাম": [
        {
          "নাম": "পাতার খোঁজে দম",
          "লিঙ্ক": "http://example.com/pat_leaf",
          "ছবি": "https://i.postimg.cc/Z9tBtWXB/download-2.jpg"
        },
        {
          "নাম": "পাটের পাতা পোকা",
          "লিঙ্ক": "http://example.com/pat_leaf_borer",
          "ছবি": "https://i.postimg.cc/Z9tBtWXB/download-2.jpg"
        },
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    cropList = cropsData; // Initialize the crop list with the embedded data
    filteredList = cropList;
    searchController.addListener(() {
      filterSearchResults(searchController.text);
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CropDetailPage(
                              cropData: filteredList[index],
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
  final dynamic cropData;

  const CropDetailPage({super.key, required this.cropData});

  @override
  Widget build(BuildContext context) {
    List<dynamic> diseaseList = cropData['রোগের নাম'];

    return Scaffold(
      appBar: AppBar(
        title: Text(cropData['ফসলের_নাম']),
        backgroundColor: const Color.fromARGB(255, 7, 255, 57),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'রোগের নাম:',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),

            // Display diseases in square cards
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Number of cards per row
                  crossAxisSpacing: 1, // Horizontal space between cards
                  mainAxisSpacing: 1, // Vertical space between cards
                  childAspectRatio: 1.0, // Aspect ratio for square shape
                ),
                itemCount: diseaseList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      launchURL(diseaseList[index]['লিঙ্ক']);
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Display image with increased height
                          Image.network(
                            diseaseList[index]['ছবি'],
                            height: 100, // Increased height for the image
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                              height: 8), // Space between image and text
                          Text(
                            diseaseList[index]['নাম'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
