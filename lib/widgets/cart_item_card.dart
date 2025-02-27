import 'package:flutter/material.dart';
import '../providers/cart_provider.dart'; // Import CartItem model if necessary

class CartItemCard extends StatelessWidget {
  final CartItem cartItem;

  CartItemCard({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Image.network(
              cartItem.imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text("₱${cartItem.price}", style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Checkbox(
              value: true, // You can control this based on your logic
              onChanged: (value) {
                // Handle checkbox toggle logic here if needed
              },
            ),
          ],
        ),
      ),
    );
  }
}
