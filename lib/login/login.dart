import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testimn/firebase_options.dart';
import 'package:testimn/openingTime/open.dart';

// import '../main.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApplog());
}

class MyApplog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatefulWidget {
  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoggedIn ? SplashScreenPage() : AuthScreen();
  }
}

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _authenticate() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final district = _districtController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      if (_isLogin) {
        // Login
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        User? user = userCredential.user;
        if (user != null && user.emailVerified) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', true);

          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SplashScreenPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Please verify your email')),
          );
        }
      } else {
        // Check if the user already exists
        final existingUser = await _auth.fetchSignInMethodsForEmail(email);
        if (existingUser.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account already exists. Please log in.')),
          );
        } else {
          // Signup
          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          User? user = userCredential.user;
          if (user != null) {
            // Save additional user information to Firestore
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set({
              'uid': user.uid,
              'name': name,
              'phone': phone,
              'district': district,
              'email': email,
            });

            await user.sendEmailVerification();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      'Verification email sent. Please check your inbox.')),
            );
          }
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailController.text.trim();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Password reset email sent. Please check your inbox.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Sign Up'),
      ),
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          elevation: 8,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin)
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                if (!_isLogin)
                  TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                  ),
                if (!_isLogin)
                  TextField(
                    controller: _districtController,
                    decoration: InputDecoration(labelText: 'District Name'),
                  ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _authenticate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text(
                    _isLogin ? 'Login' : 'Sign Up',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                if (_isLogin)
                  TextButton(
                    onPressed: _resetPassword,
                    child: Text('Forgot Password?'),
                  ),
                TextButton(
                  onPressed: _toggleForm,
                  child: Text(_isLogin
                      ? 'Create an account'
                      : 'Already have an account?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
