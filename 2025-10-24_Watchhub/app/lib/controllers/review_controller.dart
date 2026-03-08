// lib/controllers/review_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = false.obs;
  var productReviews = <Map<String, dynamic>>[].obs;
  var userReviews = <Map<String, dynamic>>[].obs;

  /// Add a review for a product and update product rating
  Future<void> addReview({
    required String productId,
    required String userId,
    required String userName,        // <-- required userName param
    required double rating,
    required String reviewText,
    String? productName,
    String? productImage,
  }) async {
    try {
      isLoading.value = true;

      final reviewData = {
        'productId': productId,
        'userId': userId,
        'userName': userName,
        'rating': rating,
        'review': reviewText,
        'productName': productName ?? '',
        'productImage': productImage ?? '',
        'date': FieldValue.serverTimestamp(),
      };

      await _firestore.collection('reviews').add(reviewData);

      // Update average rating on product doc
      await _updateProductAverageRating(productId);

      Get.snackbar('Success', 'Review added successfully');
      await fetchProductReviews(productId);
      await fetchUserReviews(userId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add review: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update product's average rating and reviews count
  Future<void> _updateProductAverageRating(String productId) async {
    try {
      final reviewsSnapshot = await _firestore
          .collection('reviews')
          .where('productId', isEqualTo: productId)
          .get();

      if (reviewsSnapshot.docs.isEmpty) return;

      double totalRating = 0;
      for (var doc in reviewsSnapshot.docs) {
        totalRating += (doc['rating'] ?? 0).toDouble();
      }
      final avgRating = totalRating / reviewsSnapshot.docs.length;

      await _firestore.collection('products').doc(productId).update({
        'rating': avgRating,
        'reviewsCount': reviewsSnapshot.docs.length,
      });
    } catch (e) {
      // don't crash the flow if update fails — just notify
      Get.snackbar('Error', 'Failed to update product rating: $e');
    }
  }

  /// Fetch product reviews (ordered newest first)
  Future<void> fetchProductReviews(String productId) async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('reviews')
          .where('productId', isEqualTo: productId)
        //  .orderBy('date', descending: true)
          .get();

      productReviews.value =
          snapshot.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product reviews: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all reviews by the current user
  Future<void> fetchUserReviews(String userId) async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('reviews')
          .where('userId', isEqualTo: userId)
         // .orderBy('date', descending: true)
          .get();

      userReviews.value =
          snapshot.docs.map((d) => {'id': d.id, ...d.data()}).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user reviews: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
