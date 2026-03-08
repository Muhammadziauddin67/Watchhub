import 'package:flutter/material.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final Color goldColor = const Color(0xFFD4AF37);

  // ✅ Corrected wishlist items with a working image URL
  List<Map<String, dynamic>> wishlistItems = [
    {
      "name": "Rolex Submariner",
      "price": "₹ 3 Lakh",
      "discount": "₹ 4 Lakh",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/3/3a/Rolex_Submariner.jpg"
    },
    {
      "name": "Rolex Submariner",
      "price": "₹ 3 Lakh",
      "discount": "₹ 4 Lakh",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/3/3a/Rolex_Submariner.jpg"
    },
    {
      "name": "Rolex Submariner",
      "price": "₹ 3 Lakh",
      "discount": "₹ 4 Lakh",
      "image":
          "https://upload.wikimedia.org/wikipedia/commons/3/3a/Rolex_Submariner.jpg"
    },
  ];

  // Function to remove item
  void removeItem(int index) {
    setState(() {
      wishlistItems.removeAt(index);
    });
  }

  // Function to add one item to cart
  void addToCart(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$name added to cart")),
    );
  }

  // Function to add all items to cart
  void addAllToCart() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All items added to cart")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Wishlist"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: wishlistItems.length,
                itemBuilder: (context, index) {
                  final item = wishlistItems[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: goldColor, width: 1.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.network(
                            item["image"],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.broken_image,
                                  color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["name"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item["price"],
                                style: TextStyle(
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                item["discount"],
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 12,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ElevatedButton(
                                onPressed: () => addToCart(item["name"]),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: goldColor,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: const Text("Add to cart"),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          color: goldColor,
                          onPressed: () => removeItem(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Add All to Cart Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(12),
              child: ElevatedButton(
                onPressed: addAllToCart,
                style: ElevatedButton.styleFrom(
                  backgroundColor: goldColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: const Text(
                  "Add All to Cart",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
