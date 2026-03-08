import 'package:flutter/material.dart';

/// WatchHub Admin – Review Management Screen
/// Theme: White (main), Black (secondary), Light Gold (accent)
const Color primaryWhite = Colors.white;
const Color secondaryBlack = Colors.black;
const Color accentGold = Color(0xFFFFD700); // Light Gold

class ReviewManagementScreen extends StatelessWidget {
  const ReviewManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Properly typed list of reviews
    final List<Map<String, dynamic>> reviews = [
      {
        'user': 'Ali Raza',
        'rating': 5,
        'comment': 'Excellent quality and fast delivery!',
        'product': 'Rolex Submariner',
      },
      {
        'user': 'Sarah Khan',
        'rating': 4,
        'comment': 'Beautiful design but packaging could improve.',
        'product': 'Casio G-Shock',
      },
      {
        'user': 'Ahsan Malik',
        'rating': 3,
        'comment': 'Average performance for the price.',
        'product': 'Seiko Chronograph',
      },
      {
        'user': 'Hassan Ahmed',
        'rating': 5,
        'comment': 'Absolutely stunning! Worth every rupee.',
        'product': 'Omega Seamaster',
      },
    ];

    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        backgroundColor: primaryWhite,
        elevation: 0.5,
        title: const Text(
          'Review Management',
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
              'Manage Customer Reviews',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: secondaryBlack,
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final review = reviews[index];
                  final String user = review['user'] as String;
                  final String product = review['product'] as String;
                  final String comment = review['comment'] as String;
                  final int rating = review['rating'] as int;

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
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ⭐ Star / Rating Badge
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: accentGold.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.star, color: accentGold),
                          ),
                          const SizedBox(width: 12),

                          // 📋 Review Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: secondaryBlack,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Product: $product',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // ⭐ Rating Row
                                Row(
                                  children: List.generate(
                                    rating,
                                    (i) => const Icon(
                                      Icons.star,
                                      size: 18,
                                      color: accentGold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // 💬 Review Comment
                                Text(
                                  '“$comment”',
                                  style: const TextStyle(
                                    color: secondaryBlack,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // 🗑️ Delete Button
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              // TODO: Delete review from Firebase
                            },
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

      // 🔄 Floating Refresh Button
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
          // TODO: Refresh review list from Firebase
        },
      ),
    );
  }
}
