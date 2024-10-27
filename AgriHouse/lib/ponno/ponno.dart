import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(AgriHouseApp());
}

class AgriHouseApp extends StatelessWidget {
  const AgriHouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriHouse',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomeScreen2(),
    );
  }
}

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen2> {
  List<Product> cart = [];

  void addToCart(Product product) {
    setState(() {
      cart.add(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
      ),
    );
  }

  void removeFromCart(Product product) {
    setState(() {
      cart.remove(product);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} removed from cart!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'AgriHouse',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Products'),
              Tab(text: 'Cart'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProductListScreen(addToCart: addToCart),
            CartScreen(cart: cart, onRemove: removeFromCart),
          ],
        ),
      ),
    );
  }
}

class ProductListScreen extends StatelessWidget {
  final List<Product> products = [
    Product(
        name: 'Organic Tomatoes',
        description: 'Fresh organic tomatoes.',
        price: 2.5,
        imageUrl: 'assets/pic/Organic Tomatoes.jpg'),
    Product(
        name: 'Fresh Spinach',
        description: 'Locally grown spinach.',
        price: 1.8,
        imageUrl: 'assets/pic/Fresh Spinach.jpg'),
    Product(
      name: 'Fresh Spinach',
      description: 'Locally grown spinach.',
      price: 1.8,
      imageUrl: 'assets/pic/Fresh Spinach.jpg',
    ),
    Product(
      name: 'Free-Range Eggs',
      description: 'Eggs from free-range hens.',
      price: 3.0,
      imageUrl: 'assets/pic/Free-Range Eggs.jpg',
    ),
    Product(
      name: 'Whole Grain Wheat',
      description: '100% whole grain wheat flour.',
      price: 1.5,
      imageUrl: 'assets/pic/Whole Grain Wheat.jpg',
    ),
    Product(
      name: 'Organic Carrots',
      description: 'Sweet and crunchy organic carrots.',
      price: 2.0,
      imageUrl: 'assets/pic/Organic Carrots.jpg',
    ),
    Product(
      name: 'Fresh Cucumbers',
      description: 'Crisp and refreshing cucumbers.',
      price: 1.2,
      imageUrl: 'assets/pic/Fresh Cucumbers.jpg',
    ),
    Product(
      name: 'Green Bell Peppers',
      description: 'Fresh and green bell peppers.',
      price: 1.5,
      imageUrl: 'assets/pic/Green Bell Peppers.jpg',
    ),
    Product(
      name: 'Sweet Potatoes',
      description: 'Delicious and nutritious sweet potatoes.',
      price: 1.8,
      imageUrl: 'assets/pic/Sweet Potatoes.jpg',
    ),
    Product(
      name: 'Zucchini',
      description: 'Freshly picked zucchini.',
      price: 1.3,
      imageUrl: 'assets/pic/Zucchini.jpg',
    ),
    Product(
      name: 'Organic Onions',
      description: 'Sweet and healthy organic onions.',
      price: 0.9,
      imageUrl: 'assets/pic/Organic Onions.jpg',
    ),
    Product(
      name: 'Garlic',
      description: 'Fresh garlic for your cooking needs.',
      price: 1.0,
      imageUrl: 'assets/pic/Garlic.jpg',
    ),
    Product(
      name: 'Lettuce',
      description: 'Crisp and fresh lettuce.',
      price: 1.2,
      imageUrl: 'assets/pic/Lettuce.jpg',
    ),
    Product(
      name: 'Radishes',
      description: 'Spicy and crunchy radishes.',
      price: 1.4,
      imageUrl: 'assets/pic/Radishes.jpg',
    ),
    Product(
      name: 'Broccoli',
      description: 'Nutritious and fresh broccoli.',
      price: 2.2,
      imageUrl: 'assets/pic/Broccoli.jpg',
    ),
    Product(
      name: 'Cauliflower',
      description: 'Fresh cauliflower for various recipes.',
      price: 2.0,
      imageUrl: 'assets/pic/Cauliflower.jpg',
    ),
    Product(
      name: 'Peas',
      description: 'Sweet and green peas.',
      price: 1.5,
      imageUrl: 'assets/pic/Peas.jpg',
    ),
    Product(
      name: 'Pumpkin',
      description: 'Fresh and healthy pumpkins.',
      price: 2.5,
      imageUrl: 'assets/pic/Pumpkin.jpg',
    ),
    Product(
      name: 'Strawberries',
      description: 'Juicy and sweet strawberries.',
      price: 3.5,
      imageUrl: 'assets/pic/Strawberries.jpg',
    ),
    Product(
      name: 'Blueberries',
      description: 'Fresh and delicious blueberries.',
      price: 4.0,
      imageUrl: 'assets/pic/Blueberries.jpg',
    ),
    Product(
      name: 'Raspberries',
      description: 'Tasty and healthy raspberries.',
      price: 4.5,
      imageUrl: 'assets/pic/Raspberries.jpg',
    ),
  ];

  final Function(Product) addToCart;

  ProductListScreen({super.key, required this.addToCart});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: constraints.maxWidth < 600 ? 2 : 4,
            childAspectRatio: 0.7,
          ),
          padding: const EdgeInsets.all(8),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(product: product, onAddToCart: addToCart);
          },
        );
      },
    );
  }
}

class Product {
  final String name;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class ProductCard extends StatelessWidget {
  final Product product;
  final Function(Product) onAddToCart;

  const ProductCard(
      {super.key, required this.product, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(8)),
              child: Image.asset(
                product.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  product.description,
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                ElevatedButton(
                  onPressed: () => onAddToCart(product),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: Text('Add to Cart'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  final List<Product> cart;
  final Function(Product) onRemove;
  final String mobileNumber = '01785479819';

  const CartScreen({super.key, required this.cart, required this.onRemove});

  void _launchPhone(BuildContext context) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: mobileNumber,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Could not launch $launchUri';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error launching phone dialer: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return cart.isEmpty
        ? const Center(child: Text('Your cart is empty'))
        : ListView(
            children: [
              Container(
                color: Colors.lightBlueAccent,
                child: ListTile(
                  title: const Text('Contact Us for Selling',
                      style: TextStyle(color: Colors.white)),
                  subtitle: Text(mobileNumber,
                      style: const TextStyle(color: Colors.white70)),
                  trailing: IconButton(
                    icon: const Icon(Icons.call, color: Colors.white),
                    onPressed: () => _launchPhone(context),
                  ),
                ),
              ),
              const Divider(),
              ...cart.map((product) {
                return ListTile(
                  leading: Image.asset(
                    product.imageUrl,
                    width: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name),
                  subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => onRemove(product),
                  ),
                );
              }),
            ],
          );
  }
}
