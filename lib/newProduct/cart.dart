import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatelessWidget {
  final List<DocumentSnapshot> cart;

  CartPage({required this.cart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.green,
      ),
      body: cart.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                final product = cart[index];
                final productData = product.data() as Map<String, dynamic>;
                return ListTile(
                  leading: Image.network(
                    productData['image'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(productData['name']),
                  subtitle:
                      Text('\$${productData['price'].toStringAsFixed(2)}'),
                );
              },
            ),
    );
  }
}
