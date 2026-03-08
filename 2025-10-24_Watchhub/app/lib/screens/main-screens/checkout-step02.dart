// file: checkout_step_02.dart
// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/controllers/order_controller.dart';
import 'package:app/auth/auth.dart'; // if you use custom auth wrapper

class CheckoutStep2 extends StatefulWidget {
  const CheckoutStep2({super.key});

  @override
  State<CheckoutStep2> createState() => _CheckoutStep2State();
}

class _CheckoutStep2State extends State<CheckoutStep2> {
  final List<Map<String, dynamic>> paymentMethods = [
    {"name": "Credit/Debit Card", "icon": Icons.credit_card},
    {"name": "Jazz Cash", "icon": Icons.account_balance_wallet},
    {"name": "Easy Paisa", "icon": Icons.payments_rounded},
    {"name": "Bank Alfalah", "icon": Icons.account_balance},
  ];

  String selectedMethod = '';

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();
    final user = FirebaseAuth.instance.currentUser;
    final String? userId = user?.uid;

    final subtotal = orderController.getSubtotal();
    final shippingFee = orderController.getShippingFee();
    final total = orderController.getTotal();

    final Color gold = const Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: const Text(
          "Checkout step 02",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: gold, width: 1),
              ),
            ),
            child: const Text(
              "Select Payment Method",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: paymentMethods.length,
              separatorBuilder: (context, index) => Divider(
                color: gold.withOpacity(0.3),
                height: 0,
              ),
              itemBuilder: (context, index) {
                final method = paymentMethods[index];
                final name = method['name'] as String;
                final isSelected = selectedMethod == name;
                return ListTile(
                  leading: Icon(method["icon"], color: gold, size: 30),
                  title: Text(name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )),
                  trailing: isSelected ? Icon(Icons.check_circle, color: gold) : null,
                  onTap: () {
                    setState(() {
                      selectedMethod = name;
                    });
                    // store selection in controller
                    orderController.setPaymentMethod(name);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: gold.withOpacity(0.3), width: 1),
              ),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Product Subtotal", style: TextStyle(fontSize: 15)),
                    Text("Rs. ${subtotal.toStringAsFixed(0)}", style: const TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Shipping Fee", style: TextStyle(fontSize: 15)),
                    Text("Rs. ${shippingFee.toStringAsFixed(0)}", style: const TextStyle(fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total:",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "Rs. ${total.toStringAsFixed(0)}",
                      style: TextStyle(color: gold, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: gold,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: () async {
                      if (userId == null) {
                        Get.snackbar("Login Required", "Please sign in to place the order");
                        return;
                      }
                      if (orderController.checkoutItems.isEmpty) {
                        Get.snackbar("No items", "No items to checkout");
                        return;
                      }
                      if (orderController.selectedAddress.value.isEmpty) {
                        Get.snackbar("Address required", "Please set a delivery address");
                        return;
                      }
                      if (orderController.selectedPaymentMethod.value.isEmpty) {
                        Get.snackbar("Payment required", "Please select a payment method");
                        return;
                      }

                      // call placeOrder which will add order in Firestore and navigate to step3
                      await orderController.placeOrder(userId);
                      // placeOrder internally does Get.offAllNamed('/checkout-step3') on success
                    },
                    child: const Text("Buy Now", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
