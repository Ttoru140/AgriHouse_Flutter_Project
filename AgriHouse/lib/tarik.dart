import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:testimn/benefits/upokar.dart';
import 'package:testimn/bmi_calculation/bmi.dart';
import 'package:testimn/creator.dart';
import 'package:testimn/firebase_options.dart';
import 'package:testimn/fosolerJat/fosoler_jat.dart';
import 'package:testimn/fosolerRog/fosoler_rog.dart';
import 'package:testimn/fungicide/chotraknashok.dart';
import 'package:testimn/home_page.dart';
import 'package:testimn/newProduct/ProductGridPage.dart';
import 'package:testimn/newProduct/addProduct.dart';
import 'package:testimn/ponno/ponno.dart';
import 'package:testimn/posting/post.dart';
import 'package:testimn/sobjiCash/cas.dart';
import 'package:testimn/zakat/zakat_info_page.dart';
import 'instruction_page.dart'; // Adjust the import path as needed
import 'package:testimn/fosolerPokamakor/poka.dart';

// Import the new PokaPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriHouse',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    MyApp_post(),
    CreatorPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade200,
                border: Border.all(color: Colors.green.shade400, width: 2),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/image/agrihouse_logo.png', // Ensure this path is correct
                  height: 40,
                  width: 40,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 8), // Space between logo and text
            Text(
              'AgriHouse',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Replace UserAccountsDrawerHeader with a simple header or any other widget
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.greenAccent,
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  'Welcome!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_max, color: Colors.orange),
              title: const Text('Create Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserProfilePage(
                            initialUsername: '',
                            initialEmail: '',
                          )), // Navigate to the UserProfilePage
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text('About Me'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatorPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.add,
                  color: Color.fromARGB(255, 0, 149, 255)),
              title: const Text('Add Product'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp3()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.orange),
              title: const Text('Properties'),
              onTap: () {
                // Handle navigation to Properties page
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.integration_instructions, color: Colors.purple),
              title: Text('Instructions'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PesticideInfoScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.purple),
              title: Text('Share'),
              onTap: () {
                _shareApp(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Post',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Creator',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

// Update UserProfilePage to accept initial values
class UserProfilePage extends StatefulWidget {
  final String initialUsername;
  final String initialEmail;

  UserProfilePage({required this.initialUsername, required this.initialEmail});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.initialUsername; // Set initial username
    _emailController.text = widget.initialEmail; // Set initial email
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _buildAvatar(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProfile,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    String initials = _getInitials(_usernameController.text);

    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.green,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) {
      return '';
    }
    List<String> parts = name.split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
  }

  void _submitProfile() {
    // Handle submission logic (e.g., save to database)
    print('Username: ${_usernameController.text}');
    print('Email: ${_emailController.text}');
  }
}

void _shareApp(BuildContext context) {
  final String text = 'Check out AgriHouse!';
  final String url = 'https://example.com';

  Share.share('$text $url');
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> topics = [
    {'emoji': '🌾', 'name': 'ফসলের জাত', 'image': 'assets/image/jat.jpg'},
    {'emoji': '🌱', 'name': 'ফসলের রোগ', 'image': 'assets/image/poka.jpg'},
    {'emoji': '🐛', 'name': 'ফসলের পোকামাকড়', 'image': 'assets/image/poka.jpg'},
    {'emoji': '🧪', 'name': 'ফসল ', 'image': 'assets/image/tech.jpg'},
    {'emoji': '🍄', 'name': 'ছত্রাক নাশক', 'image': 'assets/image/poka.jpg'},
    {'emoji': '💪', 'name': 'উপকারিতা', 'image': 'assets/image/zakat.jpg'},
    {
      'emoji': '📦',
      'name': 'পণ্য ও প্রযুক্তি',
      'image': 'assets/image/tech.jpg'
    },
    {'emoji': '💰', 'name': 'যাকাত', 'image': 'assets/image/zakat.jpg'},
    {'emoji': '🏃‍♀️', 'name': 'BMI', 'image': 'assets/image/bmi.jpg'},
    {'emoji': '🏃‍♀️', 'name': 'news', 'image': 'assets/image/bmi.jpg'},
    {'emoji': '🏃🫛', 'name': 'সবজি চাষ', 'image': 'assets/image/tech.jpg'},
    {'emoji': '🏃🫛', 'name': 'Weather', 'image': 'assets/image/tech.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return TopicCard(
            emoji: topics[index]['emoji']!,
            name: topics[index]['name']!,
            imagePath: topics[index]['image']!,
            onTap: () {
              if (topics[index]['name'] == 'ফসলের জাত') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CropListPage()),
                );
              } else if (topics[index]['name'] == 'ফসলের পোকামাকড়') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CropListPage2()),
                );
              } else if (topics[index]['name'] == 'যাকাত') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ZakatInfoPage()),
                );
              } else if (topics[index]['name'] == 'পণ্য ও প্রযুক্তি') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen2()),
                );
              } else if (topics[index]['name'] == 'উপকারিতা') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage3()),
                );
              } else if (topics[index]['name'] == 'BMI') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BMICalculator()),
                );
              } else if (topics[index]['name'] == 'ফসলের রোগ') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CropListPage4()),
                );
              } else if (topics[index]['name'] == 'ছত্রাক নাশক') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FungicidesApp()),
                );
              } else if (topics[index]['name'] == 'সবজি চাষ') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SobjiListScreen()),
                );
              } else if (topics[index]['name'] == 'ফসল ') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAppgrid()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TopicDetailPage(topicName: topics[index]['name']!),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
