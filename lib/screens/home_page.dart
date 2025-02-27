import 'package:flutter/material.dart';
import '../utils/gradient_background.dart';
import '/screens/profile_page.dart';
import '/screens/shopping_cart_page.dart'; // Import the Shopping Cart Page
import 'package:provider/provider.dart'; // Import Provider package
import '../providers/cart_provider.dart'; // Import your CartProvider

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  List<ProductCard> _allProducts = [
    ProductCard(
      imageUrl:
          'https://scontent.fcgy2-1.fna.fbcdn.net/v/t1.6435-9/142428661_108273547929761_1902377225523144529_n.jpg',
      category: 'Uniform',
      title: 'Female Set Uniform',
      price: '₱950.00',
    ),
    ProductCard(
      imageUrl:
          'https://scontent.fcgy2-1.fna.fbcdn.net/v/t39.30808-6/470233907_921986989891742_3458154799115219181_n.jpg',
      category: 'Souvenir',
      title: 'Executive Jacket',
      price: '₱1180-1400',
    ),
    ProductCard(
      imageUrl:
          'https://scontent.fcgy2-1.fna.fbcdn.net/v/t1.6435-9/142172610_108273541263095_2960045960672543555_n.jpg',
      category: 'Uniform',
      title: 'Male Set Uniform',
      price: '₱1000.00',
    ),
    ProductCard(
      imageUrl:
          'https://scontent.fcgy2-2.fna.fbcdn.net/v/t1.6435-9/144984371_109592151131234_384267384681174900_n.jpg',
      category: 'Uniform',
      title: 'Physical Education Uniform',
      price: '₱450.00',
    ),
  ];

  List<ProductCard> _filteredProducts = [];
  int _cartItemCount = 0;

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProfilePage()),
    );
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ShoppingCartPage()), // Navigate to ShoppingCartPage
    );
  }

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _allProducts
          .where((product) =>
              product.title.toLowerCase().contains(query.toLowerCase()) ||
              product.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _openSlidingPanel(ProductCard product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SlidingPanel(
          product: product,
          onAddToCart: (quantity) {
            setState(() {
              _cartItemCount += quantity;
            });
            Provider.of<CartProvider>(context, listen: false).addToCart(
              CartItem(
                  title: product.title,
                  price: double.parse(
                      product.price.replaceAll('₱', '').replaceAll('.', '')),
                  imageUrl: product.imageUrl),
            ); // Add item to cart
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Column(
          children: [
            PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Color(0x00d7cece),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  title: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("Home Page Refreshed");
                        },
                        child: Image.asset(
                          'assets/logo.png', // Replace with your logo path
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(color: Colors.white),
                          onChanged: _filterProducts,
                        ),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap:
                              _navigateToCart, // Navigate to ShoppingCartPage
                          child: Stack(
                            children: [
                              Icon(Icons.shopping_cart, color: Colors.white),
                              if (_cartItemCount > 0)
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$_cartItemCount',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 10),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            print('Notifications clicked');
                          },
                          child: Icon(Icons.notifications, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                padding: EdgeInsets.all(16),
                children: _filteredProducts.map((product) {
                  return GestureDetector(
                    onTap: () => _openSlidingPanel(product),
                    child: product,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.white70,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Handle Home navigation
              break;
            case 1:
              // Handle Notifications navigation
              break;
            case 2:
              // Navigate to Profile
              _navigateToProfile();
              break;
          }
        },
      ),
    );
  }
}

class SlidingPanel extends StatefulWidget {
  final ProductCard product;
  final Function(int) onAddToCart;

  SlidingPanel({required this.product, required this.onAddToCart});

  @override
  _SlidingPanelState createState() => _SlidingPanelState();
}

class _SlidingPanelState extends State<SlidingPanel> {
  int _quantity = 1;
  String? _selectedSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.product.title,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Image.network(widget.product.imageUrl,
              height: 100, fit: BoxFit.cover),
          SizedBox(height: 10),
          Text('Price: ${widget.product.price}',
              style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          DropdownButton<String>(
            hint: Text('Select Size'),
            value: _selectedSize,
            onChanged: (String? newValue) {
              setState(() {
                _selectedSize = newValue;
              });
            },
            items: <String>['S', 'M', 'L', 'XL']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantity:'),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      if (_quantity > 1) {
                        setState(() {
                          _quantity--;
                        });
                      }
                    },
                  ),
                  Text('$_quantity'),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        _quantity++;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton(
            child: Text('Add to Cart'),
            onPressed: () {
              if (_selectedSize != null) {
                widget.onAddToCart(_quantity);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please select a size')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String price;

  ProductCard({
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl,
                height: 90, width: double.infinity, fit: BoxFit.cover),
            SizedBox(height: 3),
            Text(category, style: TextStyle(fontSize: 10, color: Colors.grey)),
            Text(title,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            Text(price,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
