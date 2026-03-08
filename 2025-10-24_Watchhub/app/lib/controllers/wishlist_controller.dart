import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  var wishlistItems = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ✅ Add to Wishlist
  Future<void> addToWishlist(Map<String, dynamic> product, String userId) async {
    try {
      final wishlistRef = _firestore.collection('wishlists').doc(userId).collection('items');

      // 🔹 Use original product ID to check existence
      final productId = product['id'];
      if (productId == null) throw Exception('Product ID is missing');

      final query = await wishlistRef.where('productId', isEqualTo: productId).get();

      if (query.docs.isEmpty) {
        await wishlistRef.add({
          ...product,
          'productId': productId,           // store original product ID
          'timestamp': FieldValue.serverTimestamp(),
        });
        wishlistItems.add({...product, 'userId': userId});
        Get.snackbar('Wishlist', '${product['name']} added to wishlist!');
      } else {
        Get.snackbar('Wishlist', 'Product already in wishlist!');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add item: $e');
    }
  }

  // ✅ Remove from Wishlist
  Future<void> removeFromWishlist(Map<String, dynamic> product, String userId) async {
    try {
      final wishlistRef = _firestore.collection('wishlists').doc(userId).collection('items');

      final productId = product['id'];
      if (productId == null) throw Exception('Product ID is missing');

      final query = await wishlistRef.where('productId', isEqualTo: productId).get();

      for (var doc in query.docs) {
        await wishlistRef.doc(doc.id).delete();
      }

      wishlistItems.removeWhere((item) => item['id'] == productId);
      Get.snackbar('Wishlist', '${product['name']} removed from wishlist!');
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove item: $e');
    }
  }

  // ✅ Fetch Wishlist
  Future<void> fetchWishlist(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('wishlists')
          .doc(userId)
          .collection('items')
          .get();

      wishlistItems.value = snapshot.docs
          .map((doc) => {
                ...doc.data(),
                'wishlistDocId': doc.id, // keep wishlist document ID
                'userId': userId,        // include userId for convenience
              })
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch wishlist: $e');
    }
  }

  // ✅ Get Wishlist Count
  Future<int> getWishlistCount(String userId) async {
    final snapshot = await _firestore
        .collection('wishlists')
        .doc(userId)
        .collection('items')
        .get();
    return snapshot.size;
  }

  // 🔹 Migration: Ensure all existing wishlist items have productId
  Future<void> migrateWishlistItems(String userId) async {
    try {
      final wishlistRef = _firestore.collection('wishlists').doc(userId).collection('items');
      final snapshot = await wishlistRef.get();

      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (!data.containsKey('productId') && data.containsKey('id')) {
          await wishlistRef.doc(doc.id).update({'productId': data['id']});
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to migrate wishlist items: $e');
    }
  }
}
