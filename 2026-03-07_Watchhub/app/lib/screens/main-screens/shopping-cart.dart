import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/controllers/cart_controller.dart';
import 'package:app/controllers/order_controller.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final CartController _cartController = CartController();
  final _auth = FirebaseAuth.instance;
  final OrderController _orderController = Get.put(OrderController());

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please sign in to view your cart.")),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text(
          "Shopping Cart",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .where('userId', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, cartSnapshot) {
          if (!cartSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cartDocs = cartSnapshot.data!.docs;
          if (cartDocs.isEmpty) {
            return const Center(
              child: Text(
                "Your cart is empty.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            );
          }

          final futures = cartDocs.map((doc) {
            final cartData = doc.data() as Map<String, dynamic>;
            final productId = cartData['productId'];
            return FirebaseFirestore.instance
                .collection('products')
                .doc(productId)
                .get()
                .then((productDoc) => {
                      'cartId': doc.id,
                      'cartData': cartData,
                      'product': productDoc.data() ?? {},
                    });
          }).toList();

          return FutureBuilder<List<Map<String, dynamic>>>(
            future: Future.wait(futures),
            builder: (context, productsSnapshot) {
              if (!productsSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final cartItems = productsSnapshot.data!;
              double subtotal = 0.0;
              for (var item in cartItems) {
                final product = item['product'] as Map<String, dynamic>;
                final cartData = item['cartData'] as Map<String, dynamic>;
                final price = (product['price'] ?? 0).toDouble();
                final quantity = (cartData['quantity'] ?? 1).toInt();
                subtotal += price * quantity;
              }

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        final item = cartItems[index];
                        final product =
                            item['product'] as Map<String, dynamic>? ?? {};
                        final cartData =
                            item['cartData'] as Map<String, dynamic>? ?? {};
                        final docId = item['cartId'];
                        final name = product['name'] ?? 'Unknown Product';
                        final brand = product['brand'] ?? 'Unknown Brand';
                        final price = (product['price'] ?? 0).toDouble();
                        final imagePath =
                            product['image'] ?? 'assets/Images/default.jpg';
                        final quantity = (cartData['quantity'] ?? 1).toInt();

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  imagePath,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, e, s) =>
                                      const Icon(Icons.image, size: 40),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      brand,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 13),
                                    ),
                                    const SizedBox(height: 5),
                                    Text('Rs $price',
                                        style: const TextStyle(
                                            color: Colors.black87)),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.grey),
                                          onPressed: () {
                                            if (quantity > 1) {
                                              _cartController
                                                  .updateCartQuantity(
                                                      docId, quantity - 1);
                                            }
                                          },
                                        ),
                                        Text('$quantity',
                                            style:
                                                const TextStyle(fontSize: 16)),
                                        IconButton(
                                          icon: const Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.grey),
                                          onPressed: () {
                                            _cartController.updateCartQuantity(
                                                docId, quantity + 1);
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete,
                                    color: Colors.redAccent),
                                onPressed: () async {
                                  await _cartController.deleteFromCart(docId);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // 🔹 Subtotal + Checkout
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Colors.black12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Subtotal:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Rs ${subtotal.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFD4AF37),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () async {
                            await _orderController
                                .startCheckoutFromCart(user.uid);
                          },
                          child: const Text(
                            "Checkout",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
