import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:app/screens/main-screens/home.dart';
import 'package:app/screens/main-screens/shopping-cart.dart';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
               // 🔸 Clickable App Logo → Navigate to Home
          GestureDetector(
            onTap: () {
              Get.to(() => const Home()); 
              // ⬆ Replaces the current stack with Home (so user doesn’t go back endlessly)
              // You can use Get.to(() => const Home()) if you want normal push navigation.
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.amberAccent, width: 1.5),
                image: const DecorationImage(
                  image: AssetImage('assets/Images/logo/Watchhub-Logo.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 🛒 Cart + 👤 Profile Icons
          Row(
            children: [
              // 🛒 Shopping Cart → Navigate to Cart Screen
              IconButton(
                icon: Icon(LucideIcons.shoppingCart, color: const Color(0xFFD4AF37)),
                onPressed: () {
                  Get.to(() => CartPage());
                },
              ),

              const SizedBox(width: 16),

              // 👤 Profile → Opens Sidebar Widget
               IconButton(
                icon: Icon(LucideIcons.user, color: const Color(0xFFD4AF37)),
                onPressed: () {
                  // Opens the Drawer of the Scaffold that wraps this AppBar
                       Scaffold.of(context).openDrawer();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
