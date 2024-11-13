import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:testimn/newProduct/cart.dart';
import 'package:testimn/newProduct/favourite.dart';
// import 'cart_page.dart'; // Import CartPage for the cart functionality

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<String> categories = ["Fosol", "Fruit", "Sobji"];
  List<DocumentSnapshot> cart = [];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Product List'),
          backgroundColor: Colors.green,
          bottom: TabBar(
            tabs: categories
                .map((String category) => Tab(text: category))
                .toList(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartPage(cart: cart)),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Favourite(
                            cart: [],
                          )), // Navigate to AddProductPage
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: categories.map((String category) {
            return ProductGrid(
              category: category,
              onAddToCart: (product) {
                setState(() {
                  cart.add(product);
                });
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  final String category;
  final Function(DocumentSnapshot) onAddToCart;

  ProductGrid({required this.category, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('product')
          .where('category', isEqualTo: category)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No products found in $category'));
        }

        final products = snapshot.data!.docs;

        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          padding: const EdgeInsets.all(10),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final productData = product.data() as Map<String, dynamic>;

            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.network(
                        productData['image'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(Icons.broken_image,
                              size: 50, color: Colors.grey),
                        ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name: ${productData['name']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Price: \$${productData['price'].toStringAsFixed(2)}',
                          style: TextStyle(color: Colors.green),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Details: ${productData['details']}',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => onAddToCart(product),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: Text("Add to Cart"),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
