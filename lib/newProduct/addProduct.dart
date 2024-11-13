import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testimn/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp4());
}

class MyApp4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Add Product',
      theme: ThemeData(
        primarySwatch: Colors.green,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.0),
          ),
          labelStyle: TextStyle(color: Colors.green),
        ),
      ),
      home: ProductForm(),
    );
  }
}

class ProductForm extends StatefulWidget {
  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  bool _isActive = false;
  bool _isLoading = true;

  String? _selectedCategory = 'Fosol'; // Default category

  // Category options
  final List<String> _categories = ['Fosol', 'Fruit', 'Sobji'];

  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }

  Future<void> _checkUserStatus() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users') // Replace with your user collection name
          .doc(user.uid)
          .get();

      if (userDoc.exists && userDoc['isActive'] == true) {
        setState(() {
          _isActive = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isActive = false;
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isActive = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProduct() async {
    if (_isFormValid()) {
      await FirebaseFirestore.instance.collection('product').add({
        'name': _nameController.text,
        'details': _detailsController.text,
        'price': double.tryParse(_priceController.text) ?? 0,
        'image': _imageUrlController.text,
        'category': _selectedCategory, // Use selected category
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Product added successfully!')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all fields')));
    }
  }

  bool _isFormValid() {
    return _nameController.text.isNotEmpty &&
        _detailsController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _imageUrlController.text.isNotEmpty &&
        _selectedCategory != null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Add Product'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_isActive) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Access Denied'),
        ),
        body: Center(
          child: Text(
            'Permission Denied. You do not have access to this page.',
            style: TextStyle(fontSize: 18, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add a New Product',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(_nameController, 'Product Name'),
              const SizedBox(height: 16),
              _buildTextField(_detailsController, 'Product Details'),
              const SizedBox(height: 16),
              _buildTextField(
                  _priceController, 'Product Price', TextInputType.number),
              const SizedBox(height: 16),
              _buildTextField(
                  _imageUrlController, 'Image URL', TextInputType.url),
              const SizedBox(height: 16),
              _buildCategoryDropdown(), // Category dropdown
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      [TextInputType keyboardType = TextInputType.text]) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter $label',
        fillColor: Colors.white,
        filled: true,
      ),
      keyboardType: keyboardType,
      style: TextStyle(fontSize: 16),
    );
  }

  // Category dropdown
  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Category',
        fillColor: Colors.white,
        filled: true,
      ),
      items: _categories.map((category) {
        return DropdownMenuItem<String>(
          value: category,
          child: Text(category),
        );
      }).toList(),
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _saveProduct,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          textStyle: TextStyle(fontSize: 18),
        ),
        child: const Text('Save Product'),
      ),
    );
  }
}
