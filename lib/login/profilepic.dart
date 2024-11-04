import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _name;
  String? _email;
  String? _phone;
  String? _district;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = _auth.currentUser; // Get the current user

    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        setState(() {
          _name = doc['name'];
          _email = doc['email'];
          _phone = doc['phone'];
          _district = doc['district'];
        });
      } else {
        print('User document does not exist');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: Center(
        child: _name != null && _email != null
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Name: $_name', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text('Email: $_email', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text('Phone: $_phone', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text('District: $_district',
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
              )
            : CircularProgressIndicator(), // Show a loading spinner while fetching data
      ),
    );
  }
}
