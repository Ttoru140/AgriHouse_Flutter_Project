import 'package:flutter/material.dart';
import 'package:testimn/Starting/creator.dart';
// Adjust the import path as needed

void main() {
  runApp(MyApp7());
}

class MyApp7 extends StatelessWidget {
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
    InstructionScreen(),
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
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Instructions',
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

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> topics = [
    {'emoji': '🌾', 'name': 'ফসলের জাত', 'image': 'assets/image/jat.jpg'},
    {'emoji': '🌱', 'name': 'ফসলের রোগ', 'image': 'assets/image/rog.jpg'},
    {'emoji': '🐛', 'name': 'ফসলের পোকামাকড়', 'image': 'assets/image/poka.jpg'},
    {
      'emoji': '🧪',
      'name': 'ফসল উৎপাদন প্রযুক্তি',
      'image': 'assets/image/tech.jpg'
    },
    {'emoji': '🍄', 'name': 'ছত্রাক নাশক', 'image': 'assets/image/chotrak.jpg'},
    {'emoji': '💪', 'name': 'উপকারিতা', 'image': 'assets/image/benefit.jpg'},
    {
      'emoji': '📦',
      'name': 'পণ্য ও প্রযুক্তি',
      'image': 'assets/image/product.jpg'
    },
    {'emoji': '💰', 'name': 'যাকাত', 'image': 'assets/image/zakat.jpg'},
    {'emoji': '🏃‍♀️', 'name': 'BMI', 'image': 'assets/image/bmi.jpg'},
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
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TopicDetailPage(topicName: topics[index]['name']!)),
              );
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
  final String imagePath;
  final VoidCallback onTap;

  const TopicCard({
    Key? key,
    required this.emoji,
    required this.name,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [Colors.green.shade200, Colors.green.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '$emoji $name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color.fromARGB(255, 94, 17, 17),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class TopicDetailPage extends StatelessWidget {
  final String topicName;

  const TopicDetailPage({Key? key, required this.topicName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(topicName),
      ),
      body: Center(
        child: Text(
          'Details about $topicName',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

class InstructionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Instruction Screen',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
