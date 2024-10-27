import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  final Function(String, String) onSubmit; // Callback function

  UserProfilePage({required this.onSubmit}); // Constructor with callback

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _username = '';
  String _email = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _buildAvatar(),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _username = value;
                });
              },
            ),
            SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitProfile,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    String initials = _getInitials(_username);

    return CircleAvatar(
      radius: 50,
      backgroundColor: Colors.green,
      child: Text(
        initials,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) {
      return '';
    }
    List<String> parts = name.split(' ');
    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    }
  }

  void _submitProfile() {
    // Call the onSubmit callback with the username and email
    widget.onSubmit(_username, _email);
    Navigator.pop(context); // Close the UserProfilePage
  }
}
