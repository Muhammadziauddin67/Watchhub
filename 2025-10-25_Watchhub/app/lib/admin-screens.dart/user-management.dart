import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

const Color primaryWhite = Colors.white;
const Color secondaryBlack = Colors.black;
const Color accentGold = Color(0xFFFFD700);

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

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

      // ✅ Real-time Stream from Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream: firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final users = snapshot.data?.docs ?? [];

          if (users.isEmpty) {
            return const Center(
              child: Text(
                "No users found.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index].data() as Map<String, dynamic>;
              final userId = users[index].id;
              final role = user['role'] ?? 'user';

              return Card(
                color: primaryWhite,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: accentGold, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: const Icon(Icons.person, color: accentGold),
                  title: Text(
                    user['name']?.toString().isNotEmpty == true
                        ? user['name']
                        : 'Unnamed User',
                    style: const TextStyle(color: secondaryBlack),
                  ),
                  subtitle: Text(
                    user['email'] ?? 'No email',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  trailing: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, color: secondaryBlack),
                    onSelected: (value) {
                      if (value == 'makeAdmin') {
                        _updateUserRole(userId, 'admin');
                      } else if (value == 'makeUser') {
                        _updateUserRole(userId, 'user');
                      } else if (value == 'delete') {
                        _deleteUser(userId);
                      }
                    },
                    itemBuilder: (context) => [
                      if (role != 'admin')
                        const PopupMenuItem(
                          value: 'makeAdmin',
                          child: Text('Promote to Admin'),
                        ),
                      if (role == 'admin')
                        const PopupMenuItem(
                          value: 'makeUser',
                          child: Text('Demote to User'),
                        ),
                      const PopupMenuDivider(),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text(
                          'Delete User',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // ✅ Add new admin manually
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentGold,
        child: const Icon(Icons.person_add, color: secondaryBlack),
        onPressed: () {
          _showAddAdminDialog(context);
        },
      ),
    );
  }

  // 🧩 Promote / Demote a user
  void _updateUserRole(String userId, String newRole) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'role': newRole,
      });

      Get.snackbar(
        "Success",
        "User role updated to $newRole",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update role: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // 🧩 Delete a user document
  void _deleteUser(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      Get.snackbar(
        "Deleted",
        "User removed successfully",
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to delete user: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // 🧩 Dialog to manually add a new admin
  void _showAddAdminDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: primaryWhite,
        title: const Text(
          "Add New Admin",
          style: TextStyle(fontWeight: FontWeight.bold, color: secondaryBlack),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: accentGold),
            onPressed: () async {
              final name = nameController.text.trim();
              final email = emailController.text.trim();

              if (email.isEmpty || name.isEmpty) {
                Get.snackbar(
                  "Error",
                  "Name and Email required",
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
                return;
              }

              try {
                await FirebaseFirestore.instance.collection('users').add({
                  'name': name,
                  'email': email,
                  'role': 'admin',
                  'wishlist': [],
                  'cart': [],
                });
                Get.back();
                Get.snackbar(
                  "Success",
                  "New admin added",
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } catch (e) {
                Get.snackbar(
                  "Error",
                  "Failed to add admin: $e",
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
