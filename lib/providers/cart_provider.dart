import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _cartItems = [];

  List<CartItem> get cartItems => _cartItems;

  void addToCart(CartItem item) {
    _cartItems.add(item);
    notifyListeners();
  }

  double getSubtotal() {
    return _cartItems.fold(0, (sum, item) => sum + item.price);
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

class CartItem {
  final String title;
  final double price;
  final String imageUrl;

  CartItem({required this.title, required this.price, required this.imageUrl});
}
