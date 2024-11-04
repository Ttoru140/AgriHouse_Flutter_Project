import 'package:flutter/material.dart';

class SubmittedDataPage extends StatelessWidget {
  final String userName;
  final String phoneNumber;
  final String userEmail;
  final String password;

  const SubmittedDataPage({
    Key? key,
    required this.userName,
    required this.phoneNumber,
    required this.userEmail,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submitted Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Submitted Information:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Name: $userName', style: TextStyle(fontSize: 18)),
            Text('Phone: $phoneNumber', style: TextStyle(fontSize: 18)),
            Text('Email: $userEmail', style: TextStyle(fontSize: 18)),
            Text('Password: $password',
                style: TextStyle(
                    fontSize:
                        18)), // Display password (consider security implications)
          ],
        ),
      ),
    );
  }
}
