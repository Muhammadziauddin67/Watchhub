import 'package:flutter/material.dart';

class ProfileSidebar extends StatelessWidget {
  const ProfileSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🔹 Top Header (Mini icons aligned to top-right)
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 20),
            child: Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.person, color: Colors.amber, size: 28),
                  SizedBox(width: 15),
                  Icon(Icons.shopping_cart, color: Colors.amber, size: 28),
                ],
              ),
            ),
          ),

          const SizedBox(height: 30),

          // 🔹 Menu Items
          _buildMenuItem(Icons.person, "My Profile", context, '/profile'),
          _buildMenuItem(Icons.search, "Search", context, '/search'),
          _buildMenuItem(
              Icons.shopping_cart_outlined, "Cart", context, '/cart'),
          _buildMenuItem(
              Icons.favorite_border, "Wishlist", context, '/wishlist'),
          _buildMenuItem(Icons.support_agent, "Customer service", context,
              '/customerService'),

          const Spacer(),
          const Divider(color: Colors.amber, height: 1),
          _buildMenuItem(Icons.logout, "Logout", context, '/logout'),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  // 🔹 Reusable Menu Item Widget
  Widget _buildMenuItem(
      IconData icon, String title, BuildContext context, String route) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
      splashColor: Colors.amber.withOpacity(0.2),
      highlightColor: Colors.amber.withOpacity(0.1),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.amber, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        child: Row(
          children: [
            Icon(icon, color: Colors.black, size: 22),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
