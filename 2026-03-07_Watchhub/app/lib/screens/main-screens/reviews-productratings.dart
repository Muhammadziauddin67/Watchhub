import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/controllers/review_controller.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final ReviewController reviewController = Get.put(ReviewController());

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("Please sign in to view your reviews."),
        ),
      );
    }

    reviewController.fetchUserReviews(user.uid);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Reviews",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (reviewController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (reviewController.userReviews.isEmpty) {
          return const Center(child: Text("You haven't reviewed any products yet."));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: reviewController.userReviews.length,
          itemBuilder: (context, index) {
            final review = reviewController.userReviews[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  backgroundImage: AssetImage(
                    review['productImage'] ?? 'assets/Images/default-product.png',
                  ),
                ),
                title: Text(review['productName'] ?? 'Product'),
                subtitle: Text(review['review']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    review['rating'].round(),
                    (i) => const Icon(Icons.star, size: 16, color: Colors.amber),
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
