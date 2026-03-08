import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // ✅ white appbar
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.amber), // amber text
        ),
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      backgroundColor: Colors.white, // ✅ white background
      body: const Center(
        child: Text(
          'This is Cart page.',
          style: TextStyle(
            color: Colors.black, // ✅ black text for visibility
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
