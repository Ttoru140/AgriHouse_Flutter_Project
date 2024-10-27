import 'package:flutter/material.dart';
import 'api_controller.dart';

void main() {
  runApp(const SobjiCashApp());
}

class SobjiCashApp extends StatelessWidget {
  const SobjiCashApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sobji Cash',
      theme: ThemeData(
        primarySwatch: Colors.green,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
      ),
      home: const SobjiListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SobjiListScreen extends StatefulWidget {
  const SobjiListScreen({super.key});

  @override
  _SobjiListScreenState createState() => _SobjiListScreenState();
}

class _SobjiListScreenState extends State<SobjiListScreen> {
  final ApiController _apiController = ApiController();
  List<dynamic> _sobjiList = [];

  @override
  void initState() {
    super.initState();
    _fetchSobjiData();
  }

  Future<void> _fetchSobjiData() async {
    final data = await _apiController.loadSobjiData();
    setState(() {
      _sobjiList = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সবজি চাষের তথ্য'),
        centerTitle: true,
      ),
      body: _sobjiList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _sobjiList.length,
              itemBuilder: (context, index) {
                return SobjiCard(sobji: _sobjiList[index]);
              },
            ),
    );
  }
}

class SobjiCard extends StatelessWidget {
  final dynamic sobji;

  const SobjiCard({super.key, required this.sobji});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(sobji["নাম"] ?? "নাম পাওয়া যায়নি"),
        subtitle: Text(sobji["বৈজ্ঞানিক_নাম"] ?? "বৈজ্ঞানিক নাম পাওয়া যায়নি"),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SobjiDetailScreen(sobji: sobji),
            ),
          );
        },
      ),
    );
  }
}

class SobjiDetailScreen extends StatelessWidget {
  final dynamic sobji;

  const SobjiDetailScreen({super.key, required this.sobji});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sobji["নাম"] ?? "সবজি তথ্য"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildDetailSection("বৈজ্ঞানিক নাম:", sobji['বৈজ্ঞানিক_নাম']),
            _buildDetailSection("মাটি:", _formatSoilType(sobji['মাটি'])),
            _buildDetailSection("pH:", sobji['মাটি']?['পিএইচ']),
            _buildDetailSection("মাটি প্রস্তুতি:", sobji['মাটি']?['প্রস্তুতি']),
            _buildDetailSection("জাত:", sobji['বাংলাদেশে_জাত']),
            _buildDetailSection("বীজের পরিমাণ:", sobji['বীজের_পরিমাণ']),
            _buildDetailSection("পরিচর্যা:", sobji['পরিচর্যা']?['জল_দেওয়া']),
            _buildDetailSection(
                "আগাছা পরিষ্কার:", sobji['পরিচর্যা']?['আগাছা_পরিষ্কার']),
            _buildDetailSection("ফলন:", sobji['গাজর_সংগ্রহ']?['ফলন']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String? content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(content ?? "তথ্য পাওয়া যায়নি"),
        ],
      ),
    );
  }

  String _formatSoilType(Map<String, dynamic>? soil) {
    if (soil == null) return "তথ্য পাওয়া যায়নি";
    final types = soil['প্রকার'] as List<dynamic>?;
    return types != null ? types.join(', ') : "তথ্য পাওয়া যায়নি";
  }
}
