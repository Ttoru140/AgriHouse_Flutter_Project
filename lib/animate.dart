import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';

class AnimatedImagePage extends StatefulWidget {
  @override
  _AnimatedImagePageState createState() => _AnimatedImagePageState();
}

class _AnimatedImagePageState extends State<AnimatedImagePage> {
  // List of image URLs
  final List<String> imageUrls = [
    "https://i.postimg.cc/TYbThnYr/image.png",
    "https://i.postimg.cc/44Dm8fYQ/image.png",
    "https://i.postimg.cc/DygzkbFW/image.png",
    "https://i.postimg.cc/sxz3b3N9/image.png",
    "https://i.postimg.cc/1tg3H2Pd/image.png",
    "https://i.postimg.cc/tT4cPG3K/image.png",
    "https://i.postimg.cc/k4nYxPmQ/image.png",
    "https://i.postimg.cc/xTrxRmnj/image.png",
    "https://i.postimg.cc/6QNw8W9s/image.png",
    "https://i.postimg.cc/HkGstBPZ/Agri-House-2.png"
  ];

  int currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Set up the timer to switch images every 4 seconds
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      _nextImage();
    });
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _nextImage() {
    setState(() {
      currentIndex = (currentIndex + 1) % imageUrls.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30, // Set a slight height for the AppBar
        backgroundColor: Colors.green.shade700, // Slight green color
        elevation: 1, // Subtle shadow for the AppBar
        title: Text(
          "AgriHouse App",
          style: TextStyle(fontSize: 16), // Small font for a subtle look
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20), // Add some space after the AppBar
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedSwitcher(
                  duration: Duration(seconds: 1), // Set transition duration
                  child: Image.network(
                    imageUrls[currentIndex],
                    key: ValueKey<int>(currentIndex),
                    width: 300,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 50, // Adjust the position relative to the image
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: _nextImage,
                  ),
                ),
              ],
            ),
          ),
          Spacer(), // Push remaining content to the bottom
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AnimatedImagePage(),
  ));
}
