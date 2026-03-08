import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/appbar.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);
    final orders = [
      {'title': 'Rolex Submariner', 'price': 'Rs 3 Lakhs', 'review': '4.3 ★ Your Review', 'date': 'Aug 21 2024'},
      {'title': 'Rolex Submariner', 'price': 'Rs 3 Lakhs', 'review': '4.3 ★ Your Review', 'date': 'Sep 22 2024'},
      {'title': 'Rolex Submariner', 'price': 'Rs 3 Lakhs', 'review': '– Not Reviewed', 'date': 'Oct 3 2024'},
      {'title': 'Rolex Submariner', 'price': 'Rs 3 Lakhs', 'review': '4.3 ★ Your Review', 'date': 'Jan 1 2025'},
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: Container(
        color: Colors.white,
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
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final item = orders[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: gold, width: 0.8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 110,
                          height: 80,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('assets/Images/watch_sample.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(height: 3),
                                Text(item['price']!, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                                const SizedBox(height: 3),
                                Text(item['review']!, style: const TextStyle(fontSize: 12)),
                                const SizedBox(height: 3),
                                Text('Bought on ${item['date']}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
