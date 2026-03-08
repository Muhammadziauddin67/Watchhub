// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/controllers/order_controller.dart';
import 'package:app/auth/auth.dart';

class CheckoutStep1Page extends StatelessWidget {
  const CheckoutStep1Page({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.put(OrderController());
    final Authant authController = Get.put(Authant());
    final TextEditingController voucherController = TextEditingController();

    final user = authController.currentUser;
    final String? userId = user?.uid;

    final Color goldColor = const Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Checkout Step 01',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Obx(() {
        final items = orderController.checkoutItems;
        final subtotal = orderController.getSubtotal();
        final shippingFee = orderController.getShippingFee();
        final discount = orderController.voucherDiscount.value;
        final total = orderController.getTotal();

        if (items.isEmpty) {
          return const Center(
            child: Text(
              "No items to checkout!",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Checkout",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Address Section
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: goldColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on, color: goldColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Delivery Address",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text(
                            orderController.selectedAddress.value.isEmpty
                                ? "ABC Road, Central Park West"
                                : orderController.selectedAddress.value,
                            style: const TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: goldColor, size: 20),
                      onPressed: () {
                        _showAddressDialog(context, orderController);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Products Section
              ...items.map((item) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: goldColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item['image'] ?? '',
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.image_not_supported, size: 40),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'] ?? 'Product',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 4),
                            Text(item['brand'] ?? '',
                                style: const TextStyle(color: Colors.black54)),
                            const SizedBox(height: 8),
                            Text("Rs ${item['price']}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      ),
                      Text("Qty ${item['quantity']}"),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),

              // Subtotals
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: goldColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Product Subtotal"),
                        Text("Rs ${subtotal.toStringAsFixed(0)}"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Shipping Fee"),
                        Text("Rs ${shippingFee.toStringAsFixed(0)}"),
                      ],
                    ),
                    if (discount > 0) ...[
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Voucher Discount",
                              style: TextStyle(color: Colors.green)),
                          Text("- Rs ${discount.toStringAsFixed(0)}",
                              style: const TextStyle(color: Colors.green)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Voucher
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: goldColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.card_giftcard, color: goldColor),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: voucherController,
                        decoration: const InputDecoration(
                          hintText: "Enter voucher code",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        orderController.applyVoucher(voucherController.text);
                      },
                      child: Text("Apply",
                          style: TextStyle(
                              color: goldColor, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Total Section
              Container(
                decoration: BoxDecoration(
                  color: goldColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: goldColor),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Rs. ${total.toStringAsFixed(0)}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        if (discount > 0)
                          const Text("Voucher applied!",
                              style: TextStyle(
                                  color: Colors.green, fontSize: 12)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Set default address if not set
                        if (orderController.selectedAddress.value.isEmpty) {
                          orderController
                              .setAddress("ABC Road, Central Park West");
                        }
                        Get.toNamed('/checkout-step2');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: goldColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("Continue",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showAddressDialog(
      BuildContext context, OrderController orderController) {
    final TextEditingController addressController = TextEditingController(
      text: orderController.selectedAddress.value,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Address"),
        content: TextField(
          controller: addressController,
          decoration: const InputDecoration(
            hintText: "Enter your address",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              orderController.setAddress(addressController.text);
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}