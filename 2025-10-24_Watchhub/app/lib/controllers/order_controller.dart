import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';

class OrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Observable variables
  var currentOrder = <String, dynamic>{}.obs;
  var userOrders = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // Checkout data holders
  var checkoutItems = <Map<String, dynamic>>[].obs;
  var selectedAddress = ''.obs;
  var selectedPaymentMethod = ''.obs;
  var voucherCode = ''.obs;
  var voucherDiscount = 0.0.obs;

  /// ✅ Initialize checkout from cart
  Future<void> startCheckoutFromCart(String userId) async {
    try {
      if (userId.isEmpty) {
        Get.snackbar('Error', 'User not logged in.');
        return;
      }

      isLoading.value = true;

      // Fetch cart items
      final cartSnapshot = await _firestore
          .collection('cart')
          .where('userId', isEqualTo: userId)
          .get();

      if (cartSnapshot.docs.isEmpty) {
        Get.snackbar('Cart Empty', 'Your cart is empty!');
        isLoading.value = false;
        return;
      }

      // Prepare checkout items safely
      checkoutItems.value = cartSnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'cartDocId': doc.id,
          'productId': data['productId'] ?? '',
          'name': data['name'] ?? 'Unknown Product',
          'brand': data['brand'] ?? '',
          'price': (data['price'] ?? 0).toDouble(),
          'image': data['image'] ?? 'assets/Images/default.jpg',
          'quantity': (data['quantity'] ?? 1),
        };
      }).toList();

      isLoading.value = false;

      Get.toNamed('/checkout-step1');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to start checkout: $e');
    }
  }

  /// ✅ Initialize checkout from Buy Now (single product)
  Future<void> startCheckoutFromProduct(
    Map<String, dynamic> product,
    String userId,
  ) async {
    try {
      isLoading.value = true;

      // Prepare single item checkout
      checkoutItems.value = [
        {
          'productId': product['id'] ?? product['productId'],
          'name': product['name'],
          'brand': product['brand'] ?? '',
          'price': product['price'],
          'image': product['image'],
          'quantity': 1,
        },
      ];

      isLoading.value = false;

      // Navigate to checkout step 1
      Get.toNamed('/checkout-step1');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to start checkout: $e');
    }
  }

  /// ✅ Calculate subtotal
  double getSubtotal() {
    return checkoutItems.fold(0.0, (sum, item) {
      final price = (item['price'] ?? 0).toDouble();
      final quantity = (item['quantity'] ?? 1);
      return sum + (price * quantity);
    });
  }

  /// ✅ Calculate shipping fee (fixed or based on subtotal)
  double getShippingFee() {
    final subtotal = getSubtotal();
    // Free shipping over Rs 500,000, otherwise Rs 500
    return subtotal > 500000 ? 0.0 : 500.0;
  }

  /// ✅ Calculate total
  double getTotal() {
    return getSubtotal() + getShippingFee() - voucherDiscount.value;
  }

  /// ✅ Apply voucher code
  Future<void> applyVoucher(String code) async {
    try {
      if (code.isEmpty) {
        Get.snackbar('Error', 'Please enter a voucher code');
        return;
      }

      // Check voucher in Firestore
      final voucherSnapshot = await _firestore
          .collection('vouchers')
          .where('code', isEqualTo: code.toUpperCase())
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      if (voucherSnapshot.docs.isEmpty) {
        Get.snackbar('Invalid', 'Voucher code not found or expired');
        return;
      }

      final voucherData = voucherSnapshot.docs.first.data();
      final discountType =
          voucherData['discountType']; // 'percentage' or 'fixed'
      final discountValue = (voucherData['discountValue'] ?? 0).toDouble();

      if (discountType == 'percentage') {
        voucherDiscount.value = (getSubtotal() * discountValue / 100);
      } else {
        voucherDiscount.value = discountValue;
      }

      voucherCode.value = code.toUpperCase();
      Get.snackbar('Success', 'Voucher applied: Rs ${voucherDiscount.value}');
    } catch (e) {
      Get.snackbar('Error', 'Failed to apply voucher: $e');
    }
  }

  /// ✅ Set address for checkout
  void setAddress(String address) {
    selectedAddress.value = address;
  }

  /// ✅ Set payment method
  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  /// ✅ Place Order (Final Step)
  Future<void> placeOrder(String userId) async {
    try {
      isLoading.value = true;

      if (checkoutItems.isEmpty) {
        throw Exception('No items to order');
      }

      if (selectedAddress.value.isEmpty) {
        throw Exception('Please select a delivery address');
      }

      if (selectedPaymentMethod.value.isEmpty) {
        throw Exception('Please select a payment method');
      }

      // Calculate expected delivery (3 days from now)
      final orderDate = DateTime.now();
      final expectedDelivery = orderDate.add(const Duration(days: 3));

      // Create order document
      final orderData = {
        'userId': userId,
        'items': checkoutItems.map((item) {
          return {
            'productId': item['productId'],
            'name': item['name'],
            'brand': item['brand'],
            'price': item['price'],
            'image': item['image'],
            'quantity': item['quantity'],
          };
        }).toList(),
        'subtotal': getSubtotal(),
        'shippingFee': getShippingFee(),
        'voucherDiscount': voucherDiscount.value,
        'voucherCode': voucherCode.value,
        'total': getTotal(),
        'address': selectedAddress.value,
        'paymentMethod': selectedPaymentMethod.value,
        'status': 'Processing',
        'orderDate': FieldValue.serverTimestamp(),
        'expectedDelivery': Timestamp.fromDate(expectedDelivery),
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add to orders collection
      final orderRef = await _firestore.collection('orders').add(orderData);

      // If checkout was from cart, clear the cart items
      if (checkoutItems.any((item) => item.containsKey('cartDocId'))) {
        for (var item in checkoutItems) {
          if (item['cartDocId'] != null) {
            await _firestore.collection('cart').doc(item['cartDocId']).delete();
          }
        }
      }

      // Store current order for confirmation page
      currentOrder.value = {
        ...orderData,
        'orderId': orderRef.id,
        'orderDate': orderDate,
        'expectedDelivery': expectedDelivery,
      };

      isLoading.value = false;

      // Navigate to checkout step 3 (confirmation)
      Get.offAllNamed('/checkout-step3');

      Get.snackbar(
        'Success',
        'Order placed successfully!',
        backgroundColor: Get.theme.colorScheme.primary,
        colorText: Get.theme.colorScheme.onPrimary,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to place order: $e');
    }
  }

  /// ✅ Fetch user's orders
  Future<void> fetchUserOrders(String userId) async {
    try {
      isLoading.value = true;

      final ordersSnapshot = await _firestore
    .collection('orders')
    .where('userId', isEqualTo: userId)
    .get();


      userOrders.value = ordersSnapshot.docs.map((doc) {
        final data = doc.data();
        return {'orderId': doc.id, ...data};
      }).toList();

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to fetch orders: $e');
    }
  }

  /// ✅ Get orders stream (real-time updates)
  Stream<QuerySnapshot> getUserOrdersStream(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
       .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// ✅ Cancel order
  Future<void> cancelOrder(String orderId, String userId) async {
    try {
      isLoading.value = true;

      // Verify order belongs to user
      final orderDoc = await _firestore.collection('orders').doc(orderId).get();

      if (!orderDoc.exists) {
        throw Exception('Order not found');
      }

      if (orderDoc.data()!['userId'] != userId) {
        throw Exception('Unauthorized access');
      }

      // Update order status
      await _firestore.collection('orders').doc(orderId).update({
        'status': 'Cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });

      // Update local list
      final index = userOrders.indexWhere((o) => o['orderId'] == orderId);
      if (index != -1) {
        userOrders[index]['status'] = 'Cancelled';
        userOrders.refresh();
      }

      isLoading.value = false;

      Get.snackbar('Success', 'Order cancelled successfully');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to cancel order: $e');
    }
  }

  /// ✅ Reset checkout data
  void resetCheckout() {
    checkoutItems.clear();
    selectedAddress.value = '';
    selectedPaymentMethod.value = '';
    voucherCode.value = '';
    voucherDiscount.value = 0.0;
    currentOrder.clear();
  }

  /// ✅ Get single order details
  Future<Map<String, dynamic>?> getOrderDetails(String orderId) async {
    try {
      final orderDoc = await _firestore.collection('orders').doc(orderId).get();

      if (!orderDoc.exists) return null;

      return {'orderId': orderDoc.id, ...orderDoc.data()!};
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch order details: $e');
      return null;
    }
  }
}
