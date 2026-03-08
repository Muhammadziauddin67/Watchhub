import 'package:flutter/material.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Wishlist', style: TextStyle(color: Colors.amber)),
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'This is Wishlist page.',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}
