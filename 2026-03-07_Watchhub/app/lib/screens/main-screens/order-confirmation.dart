import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/controllers/order_controller.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({super.key});
  final OrderController orderController = Get.find<OrderController>();

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("Please sign in to view your orders.")),
      );
    }

    // 🔹 Fetch user orders on init
    orderController.fetchUserOrders(user!.uid);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Obx(() {
        if (orderController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orderController.userOrders.isEmpty) {
          return const Center(
            child: Text(
              "No orders found",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        final orders = orderController.userOrders;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final items = order['items'] as List<dynamic>;
            final firstItem = items.isNotEmpty ? items[0] : {};
            final image = firstItem['image'] ?? '';
            final name = firstItem['name'] ?? 'Product';
            final status = order['status'] ?? 'Unknown';
            final total = order['total'] ?? 0;
            final timestamp = order['orderDate'];
            final orderDate = timestamp is Timestamp
                ? timestamp.toDate()
                : (timestamp ?? DateTime.now());
            final formattedDate = DateFormat('dd MMM yyyy').format(orderDate);

            return Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: image.isNotEmpty
                              ? Image.network(
                                  image,
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(
                                        Icons.image_not_supported,
                                        size: 40,
                                      ),
                                )
                              : const Icon(Icons.image_not_supported, size: 80),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Total: Rs ${total.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Placed on: $formattedDate",
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status: $status",
                          style: TextStyle(
                            color: status == "Cancelled"
                                ? Colors.red
                                : (status == "Delivered"
                                      ? Colors.green
                                      : Colors.orange),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            if (order['items'] != null &&
                                order['items'].isNotEmpty) {
                              final firstProduct = Map<String, dynamic>.from(
                                order['items'][0],
                              );
                              Get.toNamed(
                                '/product-details',
                                arguments: firstProduct,
                              );
                            } else {
                              Get.snackbar(
                                'Error',
                                'No product details found for this order',
                              );
                            }
                          },

                          child: const Text("View Details"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
