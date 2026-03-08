import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:app/admin-screens.dart/add_products_screen.dart';

const Color primaryWhite = Colors.white;
const Color secondaryBlack = Colors.black;
const Color accentGold = Color(0xFFFFD700);

class ProductManagementScreen extends StatelessWidget {
  const ProductManagementScreen({super.key});

  /// ✅ Universal image builder that works for both Web + Mobile
  Widget _buildProductImage(dynamic imagePath) {
  const defaultImg = AssetImage('assets/Images/default-product.png');

  if (imagePath == null || imagePath.toString().trim().isEmpty) {
    return const CircleAvatar(backgroundImage: defaultImg);
  }

  String path = imagePath.toString().trim();

  // ✅ Auto-fix missing or malformed asset paths
  if (!path.startsWith('assets/')) {
    path = 'assets/Images/watches/$path';
  } else if (path.startsWith('assets/assets/')) {
    path = path.replaceFirst('assets/assets/', 'assets/');
  }

  // ✅ Web-safe image loading
  if (kIsWeb) {
    return CircleAvatar(
      backgroundImage: AssetImage(path),
      onBackgroundImageError: (_, __) {},
    );
  }

  // ✅ Local fallback
  if (File(path).existsSync()) {
    return CircleAvatar(backgroundImage: FileImage(File(path)));
  } else {
    return CircleAvatar(backgroundImage: AssetImage(path));
  }
}



  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        backgroundColor: primaryWhite,
        elevation: 1,
        title: const Text(
          'Product Management',
          style: TextStyle(color: secondaryBlack, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: secondaryBlack),
      ),

      // 🔄 Real-time Firestore stream
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('products').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final products = snapshot.data?.docs ?? [];

          if (products.isEmpty) {
            return const Center(
              child: Text(
                "No products available.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final data = products[index].data() as Map<String, dynamic>;
              final productId = products[index].id;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: accentGold, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: _buildProductImage(data['image']),
                  title: Text(
                    data['name'] ?? 'Unnamed Product',
                    style: const TextStyle(
                        color: secondaryBlack, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['brand'] ?? 'Unknown Brand',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      Text(
                        "PKR ${data['price'] ?? 0}",
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Get.to(() => AddProductScreen(
                                editMode: true,
                                productId: productId,
                                existingData: data,
                              ));
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _deleteProduct(productId);
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

      // ➕ Add product button
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentGold,
        child: const Icon(Icons.add, color: secondaryBlack),
        onPressed: () {
          Get.to(() => const AddProductScreen());
        },
      ),
    );
  }

  // 🗑️ Delete product from Firestore
  void _deleteProduct(String id) async {
    try {
      await FirebaseFirestore.instance.collection('products').doc(id).delete();
      Get.snackbar(
        "Deleted",
        "Product removed successfully",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete product: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
