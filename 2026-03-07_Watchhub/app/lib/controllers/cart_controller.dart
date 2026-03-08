import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ Add item to cart with product reference
  Future<void> addToCart(Map<String, dynamic> product, String userId) async {
    try {
      final cartRef = _firestore.collection('cart');
      final productsRef = _firestore.collection('products');

      // Get product ID - check both 'id' and 'productId' fields
      final productId = product['productId'] ?? product['id'];
      if (productId == null) {
        throw Exception('Product ID is missing.');
      }

      // 🔹 Check if product exists in products collection
      final productDoc = await productsRef.doc(productId).get();
      if (!productDoc.exists) {
        throw Exception('Product not found in products database.');
      }

      final productData = productDoc.data() ?? {};

      // 🔹 Check if item already exists in user's cart
      final existing = await cartRef
          .where('userId', isEqualTo: userId)
          .where('productId', isEqualTo: productId)
          .limit(1)
          .get();

      if (existing.docs.isEmpty) {
        // 🟩 Add product to cart with full details
        await cartRef.add({
          'userId': userId,
          'productId': productId,
          'name': productData['name'] ?? 'Unknown Product',
          'brand': productData['brand'] ?? 'Unknown Brand',
          'price': productData['price'] ?? 0,
          'image': productData['image'] ?? '',
          'quantity': 1,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        // 🟨 Update quantity if already in cart
        final doc = existing.docs.first;
        await cartRef.doc(doc.id).update({
          'quantity': (doc['quantity'] ?? 1) + 1,
        });
      }
    } catch (e) {
      rethrow; // Let the calling function handle the error
    }
  }

  /// 🔹 Fetch Cart Items (returns full product details)
  Stream<QuerySnapshot> getUserCartStream(String userId) {
    return _firestore
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  /// 🔹 Update Quantity
  Future<void> updateCartQuantity(String cartItemId, int newQuantity) async {
    await _firestore.collection('cart').doc(cartItemId).update({
      'quantity': newQuantity,
    });
  }

  /// 🔹 Delete Item
  Future<void> deleteFromCart(String cartItemId) async {
    await _firestore.collection('cart').doc(cartItemId).delete();
  }

  /// 🔹 Check if Item Exists
  Future<bool> isItemInCart(String userId, String productId) async {
    final snapshot = await _firestore
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  /// 🔹 Clear All Items
  Future<void> clearCart(String userId) async {
    final snapshot = await _firestore
        .collection('cart')
        .where('userId', isEqualTo: userId)
        .get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }
}