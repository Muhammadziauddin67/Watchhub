
// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/appbar.dart';
import '../widgets/sidebar.dart';
import 'package:app/auth/auth.dart';
import 'package:app/controllers/wishlist_controller.dart';
import 'package:app/controllers/cart_controller.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController = Get.put(WishlistController());
    final CartController cartController = Get.put(CartController());
    final Authant authController = Get.put(Authant());

    final user = authController.currentUser;
    final String? userId = user?.uid;

    if (userId != null) {
      wishlistController.fetchWishlist(userId);
    }

    final Color goldColor = const Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      drawer: const ProfileSidebar(),
      body: Obx(() {
        final wishlist = wishlistController.wishlistItems;

        if (wishlist.isEmpty) {
          return const Center(
            child: Text(
              "Your wishlist is empty!",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: wishlist.length,
                itemBuilder: (context, index) {
                  final product = wishlist[index];

                  // Fallbacks for missing fields
                  final String name = product['name'] ?? 'Unnamed Product';
                  final double price = (product['price'] ?? 0).toDouble();
                  final double rating = (product['rating'] ?? 4.5).toDouble();
                  final String imagePath =
                      product['image'] ?? 'assets/Images/default-product.png';

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: goldColor, width: 1),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Product Image
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.image_not_supported, size: 40),
                            ),
                          ),
                        ),

                        // Product Info
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Rs $price",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: goldColor,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Action Buttons
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  final productId = product['productId'] ?? product['id'];
                                  wishlistController.removeFromWishlist(
                                      product, userId!);
                                },
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.black,
                              ),
                              OutlinedButton(
                                onPressed: () async {
                                  try {
                                    // Get productId from wishlist item
                                    final productId = product['productId'] ?? product['id'];
                                    if (productId == null) {
                                      throw Exception('Product ID missing');
                                    }

                                    // Add to cart using the productId
                                    await cartController.addToCart(
                                        {'productId': productId}, userId!);

                                    Get.snackbar(
                                      "Cart",
                                      "$name added to cart",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      duration: const Duration(seconds: 2),
                                    );
                                  } catch (e) {
                                    Get.snackbar(
                                      "Error",
                                      "Failed to add item to cart: $e",
                                      backgroundColor: Colors.redAccent,
                                      colorText: Colors.white,
                                      snackPosition: SnackPosition.BOTTOM,
                                    );
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: goldColor, width: 1),
                                  minimumSize: const Size(80, 32),
                                ),
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: goldColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Add All to Cart
            GestureDetector(
              onTap: () async {
                if (userId == null) {
                  Get.snackbar(
                    "Error",
                    "Please login to add items to cart",
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                  return;
                }

                try {
                  int successCount = 0;
                  int failCount = 0;

                  for (var product in wishlist) {
                    try {
                      final productId = product['productId'] ?? product['id'];
                      if (productId == null) {
                        failCount++;
                        continue;
                      }

                      // Add to cart using productId
                      await cartController.addToCart(
                          {'productId': productId}, userId);
                      successCount++;
                    } catch (e) {
                      failCount++;
                      print('Failed to add ${product['name']}: $e');
                    }
                  }

                  if (successCount > 0) {
                    Get.snackbar(
                      "Cart",
                      "$successCount ${successCount == 1 ? 'item' : 'items'} added to cart",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }

                  if (failCount > 0) {
                    Get.snackbar(
                      "Warning",
                      "$failCount ${failCount == 1 ? 'item' : 'items'} failed to add",
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                } catch (e) {
                  Get.snackbar(
                    "Error",
                    "Failed to add items: $e",
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                }
              },
              child: Container(
                height: 50,
                color: goldColor,
                alignment: Alignment.center,
                child: const Text(
                  "Add All to Cart",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}