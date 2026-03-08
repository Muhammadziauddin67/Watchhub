import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/appbar.dart';
import 'package:get/get.dart';
import 'package:app/screens/main-screens/profile.dart';
import 'package:app/screens/main-screens/order-history.dart';
import 'package:app/screens/main-screens/search.dart';
import 'package:app/screens/main-screens/reviews-productratings.dart';
import 'package:app/screens/widgets/sidebar.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = List.generate(
      6,
      (index) => {
        'name': 'Rolex Submariner',
        'price': 'Rs 3 Lakhs',
        'sold': '10 sold',
        'rating': 4.7,
        'reviews': 99,
        'image':
            'assets/Images/watches/rolex.jpg', // replace with your image path
      },
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(), // your custom appbar
      ),
      drawer: const ProfileSidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔸 Current Sale Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37), // gold color
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  'Current Sale Banner',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // 🔸 Icon Row
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 🏪 Store Icon → Shop Screen
                  IconButton(
                    icon: Icon(
                      LucideIcons.store,
                      size: 28,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      Get.to(OrderHistoryScreen());
                    },
                  ),

                  // 🔍 Search Icon → Search Screen
                  IconButton(
                    icon: Icon(
                      LucideIcons.search,
                      size: 28,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      Get.to(SearchPage());
                    },
                  ),

                  // ⭐ Favorites Icon → Favorites Screen
                  IconButton(
                    icon: Icon(
                      LucideIcons.star,
                      size: 28,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      Get.to(ReviewsPage());
                    },
                  ),

                  // 👤 Profile Icon → Profile Screen
                  IconButton(
                    icon: Icon(
                      LucideIcons.user,
                      size: 28,
                      color: Colors.black87,
                    ),
                    onPressed: () {
                      Get.to(ProfilePage());
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // 🔸 Product Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.78,
              ),
              itemBuilder: (context, index) {
                final item = products[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 👈 added
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                        child: Image.asset(
                          item['image'],
                          height: 120,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['price'],
                        style: const TextStyle(
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['sold'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6), // 👈 instead of Spacer
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            LucideIcons.star,
                            color: Color(0xFFD4AF37),
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item['rating']} (${item['reviews']})',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
