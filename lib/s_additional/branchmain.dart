import 'package:flutter/material.dart';
import 'package:testimn/s_additional/branchReal.dart';
import 'package:testimn/s_additional/rajbranch.dart'; // Import BranchListScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins', // Custom font for a more professional look
      ),
      home: HomePagebranch(),
    );
  }
}

class HomePagebranch extends StatelessWidget {
  void navigateToNextPage(BuildContext context, String option) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NextPage(option: option)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Option'),
        backgroundColor: Colors.teal, // Custom AppBar color
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCard(context, 'BKB', Colors.blue, Colors.white),
            SizedBox(height: 20),
            _buildCard(context, 'RAKUB', Colors.green, Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      BuildContext context, String text, Color color, Color textColor) {
    return GestureDetector(
      onTap: () => navigateToNextPage(context, text),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // Shadow position
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 24, color: textColor, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  final String option;

  NextPage({required this.option});

  @override
  Widget build(BuildContext context) {
    String message = (option == 'BKB')
        ? 'Welcome to Bangladesh Krishi Bank!'
        : 'Welcome to Rajshahi Krishi Unnayan Bank!';

    return Scaffold(
      appBar: AppBar(
        title: Text('Message'),
        backgroundColor: Colors.teal,
        elevation: 10,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.teal.shade200, Colors.blue.shade400],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 210, 14, 168),
                    letterSpacing: 2.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                if (option == 'BKB')
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BranchListScreen(), // Navigate to BranchListScreen
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text('View Branches'),
                  ),
                if (option == 'RAKUB')
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DistrictListScreen(), // Navigate to DistrictListScreen
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text('View Branches'),
                  ),
                SizedBox(height: 20),
                _buildReturnButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReturnButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context); // Go back to the home page
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: Text('Back to Home'),
    );
  }
}
