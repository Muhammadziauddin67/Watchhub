import 'package:flutter/material.dart';

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({super.key});

  final Color goldColor = const Color(0xFFFFD700); // Golden color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Customer Services & Feedback',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Icon(Icons.shopping_cart, color: goldColor),
          const SizedBox(width: 10),
        ],
      ),
      body: Container(
        color: Colors.white,
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(Icons.headset_mic, size: 80, color: goldColor),
            const SizedBox(height: 10),
            Text(
              'Customer Support',
              style: TextStyle(fontSize: 18, color: goldColor),
            ),
            const SizedBox(height: 40),
            SupportOption(
              icon: Icons.phone,
              text: 'Call us at 999-333-222',
              onTap: () {
                print("Calling...");
              },
            ),
            SupportOption(
              icon: Icons.help_outline,
              text: 'QUESTIONS & HELP CENTER',
              onTap: () {
                print("Opening Help Center...");
              },
            ),
            SupportOption(
              icon: Icons.autorenew,
              text: 'Returns & Exchanges',
              onTap: () {
                print("Opening Returns...");
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SupportOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const SupportOption({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final Color goldColor = const Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: goldColor),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: goldColor),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 16, color: goldColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
