import 'package:flutter/material.dart';

/// --- WatchHub Theme Constants ---
const Color primaryWhite = Colors.white;
const Color secondaryBlack = Colors.black;
const Color accentGold = Color(0xFFFFD700); // Light gold accent

class OrderManagementScreen extends StatelessWidget {
  const OrderManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Example static order data — replace with Firebase later
    final orders = [
      {
        'id': 'ORD-1001',
        'customer': 'Ali Raza',
        'amount': '45,000 PKR',
        'status': 'Pending',
      },
      {
        'id': 'ORD-1002',
        'customer': 'Sarah Khan',
        'amount': '82,000 PKR',
        'status': 'Completed',
      },
      {
        'id': 'ORD-1003',
        'customer': 'Ahsan Malik',
        'amount': '51,500 PKR',
        'status': 'Cancelled',
      },
    ];

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manage Orders',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: secondaryBlack,
              ),
            ),
            const SizedBox(height: 16),

            /// --- Order List ---
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];

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
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: accentGold.withOpacity(0.2),
                        child: const Icon(
                          Icons.receipt_long,
                          color: secondaryBlack,
                        ),
                      ),
                      title: Text(
                        order['id']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: secondaryBlack,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          'Customer: ${order['customer']}\nAmount: ${order['amount']}',
                          style: const TextStyle(
                            color: Colors.grey,
                            height: 1.3,
                            fontSize: 13,
                          ),
                        ),
                      ),

                      /// --- FIXED TRAILING SECTION ---
                      trailing: Column(
                        mainAxisSize: MainAxisSize.min, // shrink to fit content
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            order['status']!,
                            style: TextStyle(
                              color: order['status'] == 'Completed'
                                  ? Colors.green
                                  : order['status'] == 'Cancelled'
                                  ? Colors.red
                                  : accentGold,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 6,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                ),
                                iconSize: 20,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  // TODO: View details
                                },
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                                iconSize: 20,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  // TODO: Mark as completed
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      /// --- Floating Action Button ---
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: accentGold,
        icon: const Icon(Icons.add, color: secondaryBlack),
        label: const Text(
          'New Order',
          style: TextStyle(color: secondaryBlack, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          // TODO: Implement Add Order functionality
        },
      ),
    );
  }
}
