import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../widgets/appbar.dart';
import '../widgets/sidebar.dart';
import 'package:app/screens/main-screens/help_centre_page.dart';
import 'package:app/screens/main-screens/returns_page.dart';

class CustomerSupportScreen extends StatelessWidget {
  const CustomerSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD4AF37);

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: CustomAppBar(),
      ),
      drawer: const ProfileSidebar(),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Icon(LucideIcons.headphones, color: gold, size: 90),
            const SizedBox(height: 12),
            const Text(
              'Customer Support',
              style: TextStyle(
                color: gold,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 50),

            _supportTile(
              icon: LucideIcons.phone,
              label: 'Call us at 555-333-222',
              onTap: () {},
            ),
            _supportTile(
              icon: LucideIcons.helpCircle,
              label: 'QUESTIONS & HELP CENTER',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HelpCenterPage()),
                );
              },
            ),
            _supportTile(
              icon: LucideIcons.refreshCw,
              label: 'Returns & Exchanges',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReturnsPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _supportTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    const gold = Color(0xFFD4AF37);
    return Container(
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: gold, width: 0.6),
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: gold),
        title: Text(
          label,
          style: const TextStyle(
            color: gold,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
