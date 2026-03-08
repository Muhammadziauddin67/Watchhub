import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('My Profile', style: TextStyle(color: Colors.amber)),
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'This is My Profile page.',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}
