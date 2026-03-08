import 'package:flutter/material.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Logout', style: TextStyle(color: Colors.amber)),
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'You have been logged out (demo page).',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}
