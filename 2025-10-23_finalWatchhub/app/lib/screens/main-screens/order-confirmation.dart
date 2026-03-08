import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // ✅ Fix: added import

void main() {
  runApp(const MaterialApp(
    home: OrderConfirmationPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class Order {
  final String productName;
  final String imageUrl;
  final double price;
  final DateTime orderDate;
  final String status;

  Order({
    required this.productName,
    required this.imageUrl,
    required this.price,
    required this.orderDate,
    required this.status,
  });
}

class OrderConfirmationPage extends StatefulWidget {
  const OrderConfirmationPage({Key? key}) : super(key: key);

  @override
  State<OrderConfirmationPage> createState() => _OrderConfirmationPageState();
}

class _OrderConfirmationPageState extends State<OrderConfirmationPage> {
  List<Order> orders = [
    Order(
      productName: "Rolex Submariner",
      imageUrl:
          "https://upload.wikimedia.org/wikipedia/commons/6/6e/Rolex_Submariner_%28114060%29.jpg",
      price: 12999.99,
      orderDate: DateTime.now(),
      status: "Processing",
    ),
  ];

  void cancelOrder(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Cancel Order"),
        content: const Text("Are you sure you want to cancel this order?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                orders.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text(
              "Yes, Cancel",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String getReceiveByDate(DateTime orderDate) {
    final receiveDate = orderDate.add(const Duration(days: 3));
    return DateFormat('dd MMM yyyy').format(receiveDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Order Confirmation",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: orders.isEmpty
          ? const Center(
              child: Text(
                "No active orders",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                order.imageUrl,
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.productName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "₹${order.price.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Status: ${order.status}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Receive by: ${getReceiveByDate(order.orderDate)}",
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black54),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () => cancelOrder(index),
                              child: const Text("Cancel"),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
