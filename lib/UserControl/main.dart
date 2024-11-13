import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testimn/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore User List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PasswordCheckPage(),
    );
  }
}

class PasswordCheckPage extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();

  void _checkPassword(BuildContext context) {
    String enteredPassword = _passwordController.text;

    if (enteredPassword == 'admin@140') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserListPage()),
      );
    } else {
      // Show an error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Access Denied'),
            content: Text(
                'Incorrect password. You do not have permission to access this page.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _checkPassword(context),
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          // If the snapshot has data
          final userDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (context, index) {
              final userData = userDocs[index].data() as Map<String, dynamic>;
              final userId = userDocs[index].id; // Get user document ID
              final userName = userData['name'] ?? 'No Name';
              final userPhone = userData['phone'] ?? 'No Phone';
              final isActive =
                  userData['isActive'] ?? false; // Fetch the boolean value

              return ListTile(
                title: Text(userName),
                subtitle: Text(userPhone),
                trailing: Switch(
                  value: isActive,
                  onChanged: (bool value) {
                    // Update the isActive field in Firestore
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .update({
                      'isActive': value,
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
