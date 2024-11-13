import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:testimn/UserControl/main.dart';
import 'package:testimn/benefits/upokar.dart';
import 'package:testimn/bmi_calculation/bmi.dart';
import 'package:testimn/Starting/creator.dart';
import 'package:testimn/fosolerJat/jat.dart';
import 'package:testimn/newProduct/main.dart';
// import 'package:testimn/s_additional/branch.dart';
import 'package:testimn/firebase_options.dart';
// import 'package:testimn/fosolerJat/fosoler_jat.dart';
import 'package:testimn/fosolerRog/fosoler_rog.dart';
import 'package:testimn/fungicide/chotraknashok.dart';
import 'package:testimn/login/login.dart';
import 'package:testimn/s_additional/branchmain.dart';
import 'package:testimn/s_additional/news.dart';
import 'package:testimn/openingTime/home_page.dart';
// import 'package:testimn/newProduct/ProductGridPage.dart';
import 'package:testimn/newProduct/addProduct.dart';
import 'package:testimn/ponno/ponno.dart';
import 'package:testimn/posting/post.dart';
import 'package:testimn/Starting/profile.dart';
import 'package:testimn/s_additional/privacy.dart';
import 'package:testimn/purefood/main.dart';
import 'package:testimn/sobjiCash/sobjiCash.dart';
import 'package:testimn/zakat/zakat_info_page.dart';
import 'instruction_page.dart'; // Adjust the import path as needed

// Import the new PokaPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp5());
}

class MyApp5 extends StatelessWidget {
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
    PostPage(),
    HomePagebranch(),
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
                  'assets/image/ag.png', // Ensure this path is correct
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
                color: const Color.fromARGB(255, 206, 194, 155),
              ),
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '🌿Welcome💐  🌼MyUser ❤️',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 186, 19, 19),
                    fontSize: 33,
                    shadows: [
                      Shadow(
                        blurRadius: 30.0,
                        color: const Color.fromARGB(255, 34, 18, 210)
                            .withOpacity(0.8),
                        offset: Offset(8.0, 8.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_max, color: Colors.orange),
              title: const Text('My Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          UserProfilePage()), // Navigate to the UserProfilePage
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.blue),
              title: Text('About Creator'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreatorPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.control_camera, color: Colors.orange),
              title: const Text('Control Pannel'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PasswordCheckPage()),
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
                  MaterialPageRoute(builder: (context) => MyApp4()),
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
              leading: const Icon(Icons.lock, color: Colors.orange),
              title: const Text('Privacy Policy'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAppPrivacy()),
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
            ListTile(
              leading: Icon(Icons.logout, color: Colors.purple),
              title: Text('Log Out'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthCheck()),
                );
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
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Creator',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Branch',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: const Color.fromARGB(255, 8, 229, 15),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

void _shareApp(BuildContext context) {
  final String text = 'Check out AgriHouse!';
  final String url = 'https://example.com';

  Share.share('$text $url');
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> topics = [
    {'emoji': '🌾', 'name': 'ফসলের জাত'},
    {'emoji': '🌱', 'name': 'ফসলের রোগ'},
    {'emoji': '💦', 'name': 'খনিজ'},
    {'emoji': '🪴', 'name': 'ফসল '},
    {'emoji': '🍄', 'name': 'ছত্রাক নাশক'},
    {'emoji': '💪', 'name': 'উপকারিতা'},
    {'emoji': '📦', 'name': 'পণ্য ও প্রযুক্তি'},
    {'emoji': '💰', 'name': 'যাকাত'},
    {'emoji': '🏃‍♀️', 'name': 'BMI'},
    {'emoji': '📰', 'name': 'news'},
    {'emoji': '🫛', 'name': 'সবজি চাষ'},
    {'emoji': '☁️', 'name': 'Weather'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8, // Slightly wider aspect ratio
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: topics.length,
        itemBuilder: (context, index) {
          return TopicCard(
            emoji: topics[index]['emoji']!,
            name: topics[index]['name']!,
            onTap: () {
              if (topics[index]['name'] == 'ফসলের জাত') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CropListPage()),
                );
              } else if (topics[index]['name'] == 'খনিজ') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ElementsPage()),
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
                  MaterialPageRoute(builder: (context) => SobjiCashApp()),
                );
              } else if (topics[index]['name'] == 'ফসল ') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAppadd()),
                );
              } else if (topics[index]['name'] == 'news') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyAppnews()),
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

class TopicCard extends StatelessWidget {
  final String emoji;
  final String name;
  final Function onTap;

  const TopicCard({
    required this.emoji,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              50), // Full circle by setting high border radius
        ),
        elevation: 4, // Reduced elevation for a subtle shadow
        color: const Color.fromARGB(
            255, 157, 193, 171), // Light background for the card
        child: Container(
          width: 100, // Set the width of the container to a fixed size
          height: 100, // Set the height of the container to match the width
          padding:
              const EdgeInsets.all(12.0), // Reduced padding for compact design
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: TextStyle(
                    fontSize:
                        24), // Slightly larger emoji for better visibility
              ),
              SizedBox(height: 4), // Small gap between emoji and name
              Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18, // Small font size for the name
                  fontWeight: FontWeight.bold,
                  color:
                      const Color.fromARGB(255, 6, 51, 5), // Subtle text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
