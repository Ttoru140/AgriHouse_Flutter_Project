import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class CartPage extends StatefulWidget {
  final List<DocumentSnapshot> cart;

  CartPage({required this.cart});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.green,
      ),
      body: widget.cart.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.cart.length,
                    itemBuilder: (context, index) {
                      final product = widget.cart[index];
                      final productData =
                          product.data() as Map<String, dynamic>;

                      return ListTile(
                        leading: Image.network(
                          productData['image'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                        title: Text(productData['name']),
                        subtitle: Text(
                            '\$${productData['price'].toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              widget.cart.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      _proceedToCheckout(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: Text(
                      'Buy Now',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  void _proceedToCheckout(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Proceed to Checkout'),
        content: Text('Are you sure you want to proceed with the purchase?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the first dialog
              _showContactOptions(context); // Show contact options
              _confirmPurchase(); // Store purchase details in Firestore
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  void _showContactOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact Options'),
        content: Text('How would you like to proceed?'),
        actions: [
          TextButton(
            onPressed: () {
              _launchPhone();
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(Icons.phone, color: Colors.green),
                SizedBox(width: 8),
                Text('Call'),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              _launchEmail();
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(Icons.email, color: Colors.green),
                SizedBox(width: 8),
                Text('Email'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmPurchase() async {
    try {
      // Store each product in the cart in Firestore
      await _firestore.collection('purchases').add({
        'products': widget.cart.map((product) {
          final productData = product.data() as Map<String, dynamic>;
          return {
            'name': productData['name'],
            'price': productData['price'],
            'image': productData['image'],
          };
        }).toList(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Purchase confirmed and stored!')),
      );
    } catch (e) {
      print('Error storing purchase details: $e');
    }
  }

  void _launchPhone() async {
    final phone = '01882524234';
    final message = 'I am willing to buy'; // Predefined message
    final url = 'sms:$phone?body=$message';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch SMS';
    }
  }

  void _launchEmail() async {
    final email = 'arifikbal140@gmail.com';
    final subject = 'Product Inquiry';
    final body = 'I am willing to buy'; // Predefined message
    final url = 'mailto:$email?subject=$subject&body=$body';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch email client';
    }
  }
}
