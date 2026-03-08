import 'package:flutter/material.dart';
import '../widgets/appbar.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color goldColor = const Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Back Button + Title Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                // Back Button (inside body)
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: goldColor, width: 1.2),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: goldColor,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Title Text
                const Text(
                  'WishList',
                  style: TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Wishlist Items List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView.builder(
                itemCount: 5, // demo data
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      border: Border.all(color: goldColor, width: 1),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Watch Image
                        Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/images/watch_sample.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        // Watch Details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Rolex Submariner",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  "Rs 3 Lakhs",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "10 sold",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: goldColor, size: 16),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "4.7 (99)",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Actions Column
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Column(
                            children: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete_outline),
                                color: Colors.black,
                                iconSize: 24,
                              ),
                              OutlinedButton(
                                onPressed: () {},
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: goldColor, width: 1),
                                  minimumSize: const Size(80, 32),
                                ),
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: goldColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // 🔹 Bottom "Add All to Cart" Button
          Container(
            height: 50,
            color: goldColor,
            alignment: Alignment.center,
            child: const Text(
              "Add All to Cart",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
