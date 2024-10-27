// zakat_info_page.dart
import 'package:flutter/material.dart';
import 'zakat_calculation_page.dart'; // যাকাত গণনা পেজটি ইমপোর্ট করা

class ZakatInfoPage extends StatelessWidget {
  const ZakatInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ইমেজ প্লেসহোল্ডার
              Center(
                child: Image.asset(
                  'assets/image/zakat_image.png', // আপনার ইমেজটি এখানে যোগ করুন
                  height: 200,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'যাকাত কী?',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'যাকাত ইসলামে একটি বাধ্যতামূলক দানের রূপ যা সম্পদ ও সঞ্চয়ের উপর বার্ষিক ভিত্তিতে প্রদান করা হয়। এটি ইসলামের পাঁচটি স্তম্ভের একটি এবং দারিদ্র্য ও গরীবদের সাহায্যে দেওয়া হয়।',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'কৃষি পণ্যের যাকাত',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'কৃষি পণ্যের যাকাত ফসল এবং কৃষিজাত পণ্যের উপর নির্ধারিত। যারা নির্দিষ্ট পরিমাণ পণ্যের মালিক, তাদের জন্য যাকাত প্রদান বাধ্যতামূলক।',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'কৃষি পণ্যের নিছাব',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'রাসূলুল্লাহ (সাঃ) বলেছেন:\n'
                'لَيْسَ فِيْمَا أَقَلُّ مِنْ خَمْسَةِ أَوْسُقٍ صَدَقَةٌ-\n'
                '“পাঁচ ওয়াসাক-এর কম উৎপন্ন ফসলের যাকাত নেই”। [বুখারী ১৪৮৪, মুসলিম ৯৭৯]\n\n'
                'যাকাতের জন্য নিছাব হলো ৭৫০ কেজি। যদি ফসল বৃষ্টির পানিতে উৎপাদিত হয়, তাহলে ১০% যাকাত দিতে হবে। আর যদি কৃত্রিম সেচের মাধ্যমে উৎপাদিত হয়, তাহলে ৫% যাকাত দিতে হবে।',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'সেচের প্রকারভেদের উপর ভিত্তি করে হিসাব',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'রাসূলুল্লাহ (সাঃ) বলেছেন:\n'
                'فِيْمَا سَقَتِ السَّمَاءُ وَالْعُيُوْنُ أَوْ كَانَ عَثَرِيًّا الْعُشْرُ، وَمَا سُقِىَ بِالنَّضْحِ نِصْفُ الْعُشْرِ-\n'
                '“যে ফসল বৃষ্টি বা প্রাকৃতিক ঝর্ণার পানি দ্বারা উৎপাদিত হয় তার উপর দশ ভাগের এক ভাগ যাকাত ওয়াজিব। আর কৃত্রিম সেচের মাধ্যমে উৎপাদিত ফসলের উপর বিশ ভাগের এক ভাগ যাকাত ওয়াজিব।” [বুখারী ১৪৮৩]',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'মিশ্র পানির উৎসের উপর যাকাত',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'যদি কিছু অংশ বৃষ্টির পানিতে এবং কিছু অংশ কৃত্রিম সেচের মাধ্যমে ফসল উৎপন্ন হয়, তাহলে যাকাতের হার নির্ধারণ করা হবে প্রধান পানির উৎসের উপর ভিত্তি করে:\n'
                '• যদি বৃষ্টির পানির পরিমাণ বেশী হয়, তাহলে ১০% যাকাত দিতে হবে।\n'
                '• যদি কৃত্রিম সেচের পরিমাণ বেশী হয়, তাহলে ৫% যাকাত দিতে হবে।\n'
                '• যদি উভয় সমানভাবে ব্যবহৃত হয়, তাহলে ৭.৫% যাকাত দিতে হবে।',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'যে সকল ফসলের উপর যাকাত ফরজ',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'যাকাত সেই ফসলের উপর ফরজ যা সংরক্ষণযোগ্য এবং মানুষের প্রধান খাদ্য হিসাবে বিবেচিত। রাসূলুল্লাহ (সাঃ) গম, যব, খেজুর ও কিসমিসের উপর যাকাত নির্ধারণ করেছেন। অন্যান্য শস্য যেমন ধান, ভুট্টা ইত্যাদিও এর অন্তর্ভুক্ত।',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              const Text(
                'শাকসবজির উপর যাকাত নেই',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'যেসব ফসল সংরক্ষণযোগ্য নয়, যেমন শাকসবজি, তাদের উপর যাকাত ফরজ নয়। তবে বিক্রয়লব্ধ অর্থ নিছাব পরিমাণ হলে এবং এক বছর পূর্ণ হলে যাকাত দিতে হবে।',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ZakatCalculationPage()),
                  );
                },
                child: const Text('যাকাত গণনা পেজে যান'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
