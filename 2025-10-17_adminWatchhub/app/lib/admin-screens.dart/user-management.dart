import 'package:flutter/material.dart';

const Color primaryWhite = Colors.white;
const Color secondaryBlack = Colors.black;
const Color accentGold = Color(0xFFFFD700);

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {'name': 'Ali Raza', 'email': 'ali@example.com', 'role': 'Customer'},
      {'name': 'Sarah Khan', 'email': 'sarah@example.com', 'role': 'Admin'},
    ];

    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: AppBar(
        backgroundColor: primaryWhite,
        elevation: 1,
        title: const Text(
          'User Management',
          style: TextStyle(color: secondaryBlack, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: secondaryBlack),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            color: primaryWhite,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: accentGold, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.person, color: accentGold),
              title: Text(user['name']!, style: const TextStyle(color: secondaryBlack)),
              subtitle: Text(user['email']!, style: const TextStyle(color: Colors.grey)),
              trailing: Text(user['role']!,
                  style: TextStyle(
                      color: user['role'] == 'Admin' ? accentGold : secondaryBlack,
                      fontWeight: FontWeight.bold)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentGold,
        child: const Icon(Icons.person_add, color: secondaryBlack),
        onPressed: () {},
      ),
    );
  }
}
