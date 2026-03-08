import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/appbar.dart';
import '../widgets/sidebar.dart'; 

class OrderHistoryScreen extends StatelessWidget {
const OrderHistoryScreen({super.key});

@override
Widget build(BuildContext context) {
const gold = Color(0xFFD4AF37);
final user = FirebaseAuth.instance.currentUser;

if (user == null) {
  return const Scaffold(
    body: Center(child: Text("Please log in to view your order history.")),
  );
}
// print("Current UID: ${user.uid}");
final ordersStream = FirebaseFirestore.instance
    .collection('orders')
    .where('userId', isEqualTo: user.uid)
   
    .snapshots();

return Scaffold(
  appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      drawer: const ProfileSidebar(),
  backgroundColor: Colors.white,
  body: Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(LucideIcons.list, color: gold),
            SizedBox(width: 8),
            Text(
              'Order History',
              style: TextStyle(
                color: gold,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: ordersStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No orders found."));
              }

              final orders = snapshot.data!.docs;

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final data =
                      orders[index].data() as Map<String, dynamic>? ?? {};

                  // Safely access product details from the "items" array
                  final items = (data['items'] as List?) ?? [];
                  final firstItem = items.isNotEmpty
                      ? items.first as Map<String, dynamic>
                      : {};

                  final productName =
                      firstItem['name'] ?? 'Unknown Product';
                  final productImage =
                      firstItem['image'] ?? 'assets/Images/default.jpg';
                  final price = firstItem['price'] ?? 0;
                  final quantity = firstItem['quantity'] ?? 1;

                  // Dates
                  final createdAt =
                      (data['createdAt'] as Timestamp?)?.toDate();
                  final formattedDate = createdAt != null
                      ? "${createdAt.day}/${createdAt.month}/${createdAt.year}"
                      : "Unknown date";

                  final status = data['status'] ?? 'Pending';
                  final paymentMethod =
                      data['paymentMethod'] ?? 'Not specified';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: gold, width: 0.8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        // Product image
                        Container(
                          width: 110,
                          height: 80,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: productImage.toString().startsWith('http')
                                  ? NetworkImage(productImage)
                                  : AssetImage(productImage)
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Product info
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  productName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Rs $price × $quantity",
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Payment: $paymentMethod",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Status: $status",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  "Ordered on $formattedDate",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  ),
);


}
}