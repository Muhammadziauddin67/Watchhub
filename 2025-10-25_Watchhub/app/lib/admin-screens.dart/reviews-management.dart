import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// WatchHub Admin – Review Management (Dynamic, Firestore Synced)
/// Theme: White (main), Black (secondary), Gold (accent)

const Color primaryWhite = Colors.white;
const Color secondaryBlack = Colors.black;
const Color accentGold = Color(0xFFFFD700);

class ReviewManagementScreen extends StatelessWidget {
const ReviewManagementScreen({super.key});

@override
Widget build(BuildContext context) {
// ✅ Fetch all reviews live from Firestore
final reviewsStream =
FirebaseFirestore.instance.collection('reviews').snapshots();

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

        // 🔹 Firestore StreamBuilder
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: reviewsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("No reviews found."),
                );
              }

              final reviews = snapshot.data!.docs;

              return ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  final data =
                      reviews[index].data() as Map<String, dynamic>;
                  final reviewId = reviews[index].id;

                  final userName = data['userName'] ?? 'Unknown User';
                  final productName =
                      data['productName'] ?? 'Unknown Product';
                  final productImage =
                      data['productImage'] ?? 'assets/Images/default-product.jpg';
                  final rating = (data['rating'] ?? 0).toInt();
                  final comment = data['review'] ?? 'No comment';

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
                          // 🖼️ Product image
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: productImage
                                        .toString()
                                        .startsWith('http')
                                    ? NetworkImage(productImage)
                                    : AssetImage(productImage)
                                        as ImageProvider,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // 📋 Review details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: secondaryBlack,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Product: $productName',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // ⭐ Rating stars
                                Row(
                                  children: List.generate(
                                    5,
                                    (i) => Icon(
                                      i < rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      size: 18,
                                      color: accentGold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // 💬 Comment
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

                          // 🗑️ Delete button
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () async {
                              await FirebaseFirestore.instance
                                  .collection('reviews')
                                  .doc(reviewId)
                                  .delete();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Review deleted successfully.'),
                                ),
                              );
                            },
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
      ],
    ),
  ),

  // 🔄 Refresh button
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
      (context as Element).reassemble(); // Just rebuild widget
    },
  ),
);


}
}