import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// --- WatchHub Admin Order Management (With Product Image + Dual Dropdowns) ---
const Color primaryWhite = Colors.white;
const Color secondaryBlack = Colors.black;
const Color accentGold = Color(0xFFFFD700);

class OrderManagementScreen extends StatelessWidget {
const OrderManagementScreen({super.key});

@override
Widget build(BuildContext context) {
final ordersStream =
FirebaseFirestore.instance.collection('orders').snapshots();

return Scaffold(
  backgroundColor: primaryWhite,
  appBar: AppBar(
    backgroundColor: primaryWhite,
    elevation: 0.6,
    title: const Text(
      'Order Management',
      style: TextStyle(
        color: secondaryBlack,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    iconTheme: const IconThemeData(color: secondaryBlack),
  ),
  body: Padding(
    padding: const EdgeInsets.all(16),
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
            final orderData =
                orders[index].data() as Map<String, dynamic>;
            final orderId = orders[index].id;

            final userId = orderData['userId'] ?? 'Unknown';
            final total = orderData['total'] ?? 0;
            final payment = orderData['paymentMethod'] ?? 'Not specified';
            final address = orderData['address'] ?? 'No address';
            final items = (orderData['items'] as List?) ?? [];
            final firstItem = items.isNotEmpty
                ? items.first as Map<String, dynamic>
                : {};
            final productImage =
                firstItem['image'] ?? 'assets/Images/default.jpg';
            final productName =
                firstItem['name'] ?? 'Unnamed Product';
            final quantity = firstItem['quantity'] ?? 1;

            final status = orderData['status'] ?? 'Processing';
            final delivery = orderData['deliveryStatus'] ?? 'At Facility';

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              color: primaryWhite,
              elevation: 3,
              shadowColor: accentGold.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: accentGold.withOpacity(0.6),
                  width: 1,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🖼️ Product Image
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: productImage.toString().startsWith('http')
                              ? NetworkImage(productImage)
                              : AssetImage(productImage)
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // 📦 Order Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID: $orderId',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: secondaryBlack,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Product: $productName ($quantity×)',
                            style: const TextStyle(
                                fontSize: 13, color: Colors.grey),
                          ),
                          Text('User: $userId',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey)),
                          Text('Payment: $payment',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey)),
                          Text('Total: Rs $total',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey)),
                          Text('Address: $address',
                              style: const TextStyle(
                                  fontSize: 13, color: Colors.grey)),
                          const SizedBox(height: 8),

                          // 🔽 Status Dropdown
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: status,
                                  decoration: const InputDecoration(
                                    labelText: 'Status',
                                    labelStyle:
                                        TextStyle(color: secondaryBlack),
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                  ),
                                  dropdownColor: Colors.white,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'Processing',
                                        child: Text('Processing')),
                                    DropdownMenuItem(
                                        value: 'Completed',
                                        child: Text('Completed')),
                                    DropdownMenuItem(
                                        value: 'Cancelled',
                                        child: Text('Cancelled')),
                                  ],
                                  onChanged: (value) async {
                                    if (value != null) {
                                      await FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(orderId)
                                          .update({'status': value});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Order status updated to $value')));
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),

                              // 🚚 Delivery Dropdown
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: delivery,
                                  decoration: const InputDecoration(
                                    labelText: 'Delivery',
                                    labelStyle:
                                        TextStyle(color: secondaryBlack),
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                  ),
                                  dropdownColor: Colors.white,
                                  items: const [
                                    DropdownMenuItem(
                                        value: 'At Facility',
                                        child: Text('At Facility')),
                                    DropdownMenuItem(
                                        value: 'Packed',
                                        child: Text('Packed')),
                                    DropdownMenuItem(
                                        value: 'Shipped',
                                        child: Text('Shipped')),
                                  ],
                                  onChanged: (value) async {
                                    if (value != null) {
                                      await FirebaseFirestore.instance
                                          .collection('orders')
                                          .doc(orderId)
                                          .update(
                                              {'deliveryStatus': value});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Delivery updated to $value')));
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ),
  ),

  floatingActionButton: FloatingActionButton.extended(
    backgroundColor: accentGold,
    icon: const Icon(Icons.refresh, color: secondaryBlack),
    label: const Text(
      'Refresh',
      style: TextStyle(
        color: secondaryBlack,
        fontWeight: FontWeight.bold,
      ),
    ),
    onPressed: () {
      (context as Element).reassemble();
    },
  ),
);


}
}