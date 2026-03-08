// lib/screens/main-screens/product-details.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:app/controllers/cart_controller.dart';
import 'package:app/controllers/wishlist_controller.dart';
import 'package:app/controllers/order_controller.dart';
import 'package:app/controllers/review_controller.dart';
import '../widgets/appbar.dart';
import '../widgets/sidebar.dart';

class ProductDetailsPage extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final WishlistController wishlistController = Get.put(WishlistController());
    final CartController cartController = CartController();
    final OrderController orderController = Get.find<OrderController>();
    final user = FirebaseAuth.instance.currentUser;
    final String? userId = user?.uid;

    Future<void> handleAddToWishlist() async {
      if (userId == null) {
        Get.snackbar("Login Required", "Please sign in to add to wishlist");
        return;
      }
      await wishlistController.addToWishlist(product, userId);
    }

    Future<void> handleAddToCart() async {
      if (userId == null) {
        Get.snackbar("Login Required", "Please sign in to add to cart");
        return;
      }
      await cartController.addToCart(product, userId);
      Get.snackbar("Cart", "Item added to your cart!");
    }

    return Scaffold(
      backgroundColor: Colors.white,
   appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      drawer: const ProfileSidebar(),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                // Product Image
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      product['image'] ?? 'assets/Images/default.jpg',
                      height: 280,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.image, size: 100),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Brand bar
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        product['brandImage'] ??
                            'assets/Images/brands/default.png',
                        width: 30,
                        height: 30,
                        errorBuilder: (c, e, s) =>
                            const Icon(Icons.watch, color: Color(0xFFD4AF37)),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        product['brand'] ?? 'Unknown Brand',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // Title & Price
                Text(
                  product['name'] ?? 'Product Name',
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  "Rs ${product['price']?.toString() ?? '0'}",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Color(0xFFD4AF37),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 12),

                // Rating + sold
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      "${product['rating'] ?? 0}",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "${product['sold'] ?? 0} sold",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (userId == null) {
                            Get.snackbar("Login Required",
                                "Please sign in to continue");
                            return;
                          }

                          final productForCheckout = {
                            'id': product['id'] ?? product['productId'],
                            'name': product['name'],
                            'brand': product['brand'],
                            'price': product['price'],
                            'image': product['image'],
                            'quantity': 1,
                          };

                          await orderController.startCheckoutFromProduct(
                              productForCheckout, userId);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD4AF37),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text("BUY NOW",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: handleAddToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFD4AF37)),
                      ),
                      child: const Icon(Icons.shopping_cart,
                          color: Color(0xFFD4AF37)),
                    ),
                  ],
                ),

                const SizedBox(height: 20),
                const Text(
                  "Product Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(product['description'] ?? 'No description available.'),
                const SizedBox(height: 30),
                const Divider(thickness: 1),
                const SizedBox(height: 10),

                // ✅ REVIEW SECTION
                ReviewSection(
                  productId: product['id'] ?? product['productId'] ?? '',
                  productName: product['name'] ?? 'Unknown Product',
                  productImage: product['image'] ?? 'assets/Images/default.jpg',
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),

          // wishlist & back buttons
          Positioned(
            top: 10,
            right: 12,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.favorite_border, color: Colors.black),
                onPressed: handleAddToWishlist,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 12,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Get.back(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// ✅ ReviewSection widget
/// ---------------------------------------------------------------------------
class ReviewSection extends StatefulWidget {
  final String productId;
  final String productName;
  final String productImage;

  const ReviewSection({
    super.key,
    required this.productId,
    required this.productName,
    required this.productImage,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  final ReviewController reviewController = Get.put(ReviewController());
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController reviewControllerText = TextEditingController();
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.productId.isNotEmpty) {
      reviewController.fetchProductReviews(widget.productId);
    }
  }

  @override
  void dispose() {
    reviewControllerText.dispose();
    super.dispose();
  }

  Widget _buildStars(double r) {
    final int full = r.floor();
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < full ? Icons.star : Icons.star_border,
          size: 16,
          color: Colors.amber,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Customer Reviews",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 10),

        Obx(() {
          if (reviewController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (reviewController.productReviews.isEmpty) {
            return const Text("No reviews yet. Be the first to review!");
          }

          return Column(
            children: reviewController.productReviews.map((review) {
              final date = (review['date'] as Timestamp?)?.toDate();
              final double reviewRating = (review['rating'] ?? 0).toDouble();
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(
                    review['userName'] ?? 'Anonymous',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review['review'] ?? ''),
                      const SizedBox(height: 6),
                      if (date != null)
                        Text(
                          "${date.day}/${date.month}/${date.year}",
                          style: const TextStyle(
                              fontSize: 12, color: Colors.grey),
                        ),
                    ],
                  ),
                  trailing: _buildStars(reviewRating),
                ),
              );
            }).toList(),
          );
        }),

        const SizedBox(height: 16),
        const Divider(),

        if (user != null) ...[
          const SizedBox(height: 10),
          const Text("Write a Review",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              final starIndex = index + 1;
              return IconButton(
                icon: Icon(
                  starIndex <= rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () => setState(() => rating = starIndex.toDouble()),
              );
            }),
          ),
          TextField(
            controller: reviewControllerText,
            decoration: const InputDecoration(
              hintText: "Write your review...",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              if (rating == 0 || reviewControllerText.text.trim().isEmpty) {
                Get.snackbar('Error', 'Please add a rating and review text');
                return;
              }

              final userName =
                  user?.displayName?.isNotEmpty == true ? user!.displayName! : user!.email ?? 'User';

              try {
                await reviewController.addReview(
                  productId: widget.productId,
                  userId: user!.uid,
                  userName: userName,
                  rating: rating,
                  reviewText: reviewControllerText.text.trim(),
                  productName: widget.productName,
                  productImage: widget.productImage,
                );

                reviewControllerText.clear();
                setState(() => rating = 0);
              } catch (e) {
                Get.snackbar('Error', 'Failed to submit review: $e');
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37)),
            child: const Text("Submit Review",
                style: TextStyle(color: Colors.white)),
          ),
        ] else
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("Please sign in to leave a review."),
          ),
      ],
    );
  }
}
