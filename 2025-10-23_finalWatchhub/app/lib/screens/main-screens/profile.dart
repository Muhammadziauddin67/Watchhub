import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color goldColor = const Color(0xFFD4AF37);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 254, 254),
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // Profile Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: goldColor, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black12,
                        child: Icon(Icons.person, size: 40, color: Colors.black54),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Williams",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Icon(Icons.edit, size: 16, color: goldColor),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    "Address: ABC Road, Central Park West",
                                    style: TextStyle(fontSize: 13, color: Colors.black54),
                                  ),
                                ),
                                Icon(Icons.edit, size: 16, color: goldColor),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Icon Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _iconCircle(Icons.search, goldColor),
                    _iconCircle(Icons.credit_card, goldColor),
                    _iconCircle(Icons.wallet, goldColor),
                    _iconCircle(Icons.settings, goldColor),
                  ],
                ),
                const SizedBox(height: 25),

                // Menu Items
                _menuItem(Icons.grid_view_rounded, "ORDER HISTORY", goldColor),
                const SizedBox(height: 10),
                _menuItem(Icons.star, "REVIEW CENTRE", goldColor),
                const SizedBox(height: 10),
                _menuItem(Icons.help_outline, "QUESTIONS & HELP CENTER", goldColor,
                    subtitle: "Call us at 966-800-221"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconCircle(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _menuItem(IconData icon, String title, Color color, {String? subtitle}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: color, fontSize: 15)),
                if (subtitle != null)
                  Text(subtitle,
                      style: TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
