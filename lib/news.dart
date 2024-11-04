import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyAppnews());
}

class MyAppnews extends StatelessWidget {
  const MyAppnews({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BARI News & Journals',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto', // Use a professional font
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // URLs for agricultural resources
  final List<Map<String, String>> urls = [
    {
      'label': 'Bangladesh Agricultural Research Council (BARC) Journals',
      'url': 'https://www.sac.org.bd/journals/'
    },
    {
      'label':
          'International Institute for Science, Technology and Education (IISTE) Journal',
      'url': 'https://www.iiste.org/Journals/index.php/JEES/article/view/10247'
    },
    {
      'label': 'Rajshahi University Agriculture Department',
      'url': 'https://www.ru.ac.bd/agriculture/'
    },
    {
      'label': 'National Agricultural Technology Program',
      'url': 'https://nata.gov.bd/'
    },
    {
      'label': 'Agricultural Training Institute Gazipur',
      'url': 'https://ati.gazipur.gov.bd/'
    },
    {
      'label': 'Department of Youth Development',
      'url': 'https://dyd.gov.bd/site/page/367ceed0-37c8-4c37-9182-05fade9222a9'
    },
    {
      'label': 'View BARI Journals and News',
      'url':
          'https://bari.gov.bd/site/page/f5301215-79cf-4470-a00f-715c8756754a/জার্নাল-ও-সংবাদ'
    },
    {
      'label': 'BD Journal Agriculture Section',
      'url': 'https://www.bd-journal.com/economics/agriculture'
    },
    {
      'label': 'Journal of BINA',
      'url': 'https://bina.gov.bd/site/view/publications/Journal-of-BINA'
    },
    {
      'label': 'Bangladesh Journal of Nematology',
      'url': 'https://www.bjna.info/'
    },
    {
      'label': 'Bangladesh Agricultural University',
      'url': 'https://jbau.bau.edu.bd/index.php/home/index'
    },
  ];

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Bangladesh Agricultural Information',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      blurRadius: 8,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Text(
                'Exploring Innovations in Agriculture Research and Development',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              // Dynamic buttons for each URL
              Expanded(
                child: ListView.builder(
                  itemCount: urls.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () => _launchURL(urls[index]['url']!),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 20.0),
                          backgroundColor: Colors.greenAccent.shade700,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          urls[index]['label']!,
                          style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white), // Smaller font size
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
