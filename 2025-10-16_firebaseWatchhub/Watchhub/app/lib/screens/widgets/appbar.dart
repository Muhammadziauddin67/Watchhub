import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(LucideIcons.clock, color: Color(0xFFD4AF37)),
          Row(
            children: [
              Icon(LucideIcons.shoppingCart, color: Color(0xFFD4AF37)),
              SizedBox(width: 16),
              Icon(LucideIcons.user, color: Color(0xFFD4AF37)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
