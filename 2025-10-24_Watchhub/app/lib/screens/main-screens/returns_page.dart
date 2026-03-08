import 'package:flutter/material.dart';

class ReturnsPage extends StatelessWidget {
  const ReturnsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: gold),
        title: const Text(
          'Returns & Exchanges',
          style: TextStyle(color: gold, fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text('''


Our Return & Exchange Policy

At WatchHub, we want you to love your purchase. If you are not completely satisfied, you can return or exchange your item within 7 days of delivery.

Conditions:

The product must be unused and in its original packaging.

Proof of purchase (invoice) is required.

Watches with signs of wear, scratches, or altered serial numbers are not eligible.

How to Return:

Contact our support team to initiate the return.

Pack your item securely.

Ship to our return center (address provided after approval).

Refunds are processed within 5-7 business days of receiving the returned product.
''', style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.5)),
        ),
      ),
    );
  }
}
