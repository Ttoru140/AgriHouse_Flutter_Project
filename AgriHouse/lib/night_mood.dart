import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Day and Night Mood',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MoodPage(),
    );
  }
}

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  _MoodPageState createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  bool isDayMood = true; // Initial mood is Day

  void toggleMood() {
    setState(() {
      isDayMood = !isDayMood; // Toggle the mood
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day and Night Mood'),
      ),
      body: Container(
        color: isDayMood ? Colors.lightBlue[100] : Colors.grey[900],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isDayMood ? '🌞 Day Mood' : '🌙 Night Mood',
                style: TextStyle(
                  fontSize: 32,
                  color: isDayMood ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: toggleMood,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    isDayMood ? Colors.blue : Colors.indigo,
                  ),
                ),
                child: Text(
                  isDayMood ? 'Switch to Night' : 'Switch to Day',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
