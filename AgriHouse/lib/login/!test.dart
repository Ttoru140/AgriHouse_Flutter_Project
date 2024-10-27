import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testimn/firebase_options.dart';
import 'submitted_data.dart';

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
      title: 'Firestore Form Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyFormPage(),
    );
  }
}

class MyFormPage extends StatefulWidget {
  @override
  _MyFormPageState createState() => _MyFormPageState();
}

class _MyFormPageState extends State<MyFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> _submitData() async {
    if (_formKey.currentState!.validate()) {
      String userName = _userNameController.text;
      String phoneNumber = _phoneNumberController.text;
      String userEmail = _userEmailController.text;
      String password = _passwordController.text;

      // Save data to Firestore
      await FirebaseFirestore.instance.collection('user').add({
        'userName': userName,
        'phoneNumber': phoneNumber,
        'userEmail': userEmail,
        'password':
            password, // Storing password (not recommended for production)
      });

      // Clear form fields
      _userNameController.clear();
      _phoneNumberController.clear();
      _userEmailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();

      // Navigate to SubmittedDataPage with the submitted data
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SubmittedDataPage(
            userName: userName,
            phoneNumber: phoneNumber,
            userEmail: userEmail,
            password: password,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade800,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildTextField(
                          controller: _userNameController,
                          label: 'User Name',
                          icon: Icons.person,
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          controller: _phoneNumberController,
                          label: 'Phone Number',
                          icon: Icons.phone,
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          controller: _userEmailController,
                          label: 'User Email',
                          icon: Icons.email,
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        SizedBox(height: 10),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitData,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 40, vertical: 12),
                          ),
                          child: Text(
                            'Submit',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        filled: true,
        fillColor: Colors.blue.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _phoneNumberController.dispose();
    _userEmailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
