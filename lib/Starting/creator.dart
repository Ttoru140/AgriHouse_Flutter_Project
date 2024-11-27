import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Pesticide Use',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: CreatorPage(),
    );
  }
}

class CreatorPage extends StatelessWidget {
  const CreatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'About the Creator',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 70,
                backgroundImage:
                    AssetImage('assets/image/arif.jpg'), // Local image
              ),
              const SizedBox(height: 20),
              const Text(
                'ARIF IKBAL TARIK',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 125, 46, 57),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              _buildBiographyCard(),
              const SizedBox(height: 20),
              _buildConnectCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBiographyCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Biography:',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700]),
            ),
            const SizedBox(height: 10),
            const Text(
              'A brief biography about myself goes here. I am from Rajshahi University. I like eating ruti with beaf. Sometimes I read islamic book whenever i have time',
              style:
                  TextStyle(fontSize: 16.0, height: 1.5, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect with me:',
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700]),
            ),
            const SizedBox(height: 10),
            _buildContactRow(
                Icons.link, 'Website', 'https://www.yourwebsite.com'),
            _buildContactRow(FontAwesomeIcons.facebook, 'Facebook',
                'https://www.facebook.com/yourprofile'),
            _buildContactRow(FontAwesomeIcons.github, 'GitHub',
                'https://github.com/Ttoru140'),
            _buildContactRow(FontAwesomeIcons.twitter, 'Twitter',
                'https://twitter.com/yourtwitterhandle'),
            _buildContactRow(Icons.email, 'Email', 'arifikbal140@gmail.com'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String url) {
    return GestureDetector(
      onTap: () => _launchURL(url),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 16.0, color: Colors.black87))),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
