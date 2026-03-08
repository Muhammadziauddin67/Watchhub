import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

// Navigate to these pages
import 'package:app/screens/main-screens/order-history.dart';
import 'package:app/screens/main-screens/reviews-productratings.dart';
import 'package:app/screens/main-screens/customersupport-feedback.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isEditing = false;
  bool isLoading = true;

  String? profilePicPath; // local (mobile)
  String? profilePicBase64; // web
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  // ✅ Fetch user data from Firestore
  Future<void> fetchUserProfile() async {
    try {
      final uid = _auth.currentUser!.uid;
      final doc = await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        userData = doc.data();
        nameController.text = userData?['name'] ?? '';
        phoneController.text = userData?['phone'] ?? '';
        addressController.text = userData?['address']?['street'] ?? '';

        if (kIsWeb) {
          profilePicBase64 = userData?['profilePicWeb'];
        } else {
          profilePicPath = userData?['profilePicLocal'];
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load profile: $e",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }

    setState(() => isLoading = false);
  }

  // ✅ Save updates to Firestore
  Future<void> saveUserProfile() async {
    try {
      final uid = _auth.currentUser!.uid;

      await _firestore.collection('users').doc(uid).update({
        "name": nameController.text.trim(),
        "phone": phoneController.text.trim(),
        "address": {
          "street": addressController.text.trim(),
          "city": userData?['address']?['city'] ?? '',
          "postalCode": userData?['address']?['postalCode'] ?? '',
          "country": userData?['address']?['country'] ?? '',
        },
        "profilePicLocal": profilePicPath ?? "",
        "profilePicWeb": profilePicBase64 ?? "",
      });

      Get.snackbar("Success", "Profile updated successfully",
          backgroundColor: Colors.green, colorText: Colors.white);

      setState(() => isEditing = false);
    } catch (e) {
      Get.snackbar("Error", "Failed to save profile: $e",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  // ✅ Platform-safe image getter
  ImageProvider _getProfileImage() {
    if (kIsWeb) {
      if (profilePicBase64 != null && profilePicBase64!.isNotEmpty) {
        return MemoryImage(base64Decode(profilePicBase64!));
      } else {
        return const AssetImage('assets/Images/default-user.jpg');
      }
    }

    if (profilePicPath != null && File(profilePicPath!).existsSync()) {
      return FileImage(File(profilePicPath!));
    }

    return const AssetImage('assets/Images/default-user.jpg');
  }

  // ✅ Pick and save locally (mobile) or as base64 (web)
  Future<void> pickAndSaveLocalProfilePic() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) {
        Get.snackbar("No Image", "No image selected",
            backgroundColor: Colors.amber, colorText: Colors.black);
        return;
      }

      final uid = _auth.currentUser!.uid;

      if (kIsWeb) {
        // Web: convert to base64
        final bytes = await pickedFile.readAsBytes();
        final base64Str = base64Encode(bytes);

        await _firestore.collection('users').doc(uid).update({
          "profilePicWeb": base64Str,
        });

        setState(() => profilePicBase64 = base64Str);
      } else {
        // Mobile: save locally
        final appDir = await getApplicationDocumentsDirectory();
        final userDir = Directory('${appDir.path}/Images/users/$uid');
        if (!await userDir.exists()) {
          await userDir.create(recursive: true);
        }

        final localPath = '${userDir.path}/profile.jpg';
        final savedImage = await File(pickedFile.path).copy(localPath);

        await _firestore.collection('users').doc(uid).update({
          "profilePicLocal": savedImage.path,
        });

        setState(() => profilePicPath = savedImage.path);
      }

      Get.snackbar("Profile Updated", "Profile picture saved",
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar("Error", "Failed to save image: $e",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color goldColor = const Color(0xFFD4AF37);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          if (!isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => isEditing = true),
            ),
          if (isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: saveUserProfile,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🧑 Profile Picture
            GestureDetector(
              onTap: pickAndSaveLocalProfilePic,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.black12,
                backgroundImage: _getProfileImage(),
                child: (profilePicBase64 == null && profilePicPath == null)
                    ? const Icon(Icons.person, size: 50, color: Colors.black54)
                    : null,
              ),
            ),
            const SizedBox(height: 8),
            const Text("Tap image to change",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 20),

            _editableTextField(
              controller: nameController,
              label: "Name",
              goldColor: goldColor,
              isEditing: isEditing,
            ),
            const SizedBox(height: 10),
            _editableTextField(
              controller: phoneController,
              label: "Phone",
              goldColor: goldColor,
              isEditing: isEditing,
            ),
            const SizedBox(height: 10),
            _editableTextField(
              controller: addressController,
              label: "Address",
              goldColor: goldColor,
              isEditing: isEditing,
            ),
            const SizedBox(height: 20),

            // Email (non-editable)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: goldColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.email_outlined),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      userData?['email'] ?? '',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // Navigation buttons
            _menuItem(Icons.grid_view_rounded, "ORDER HISTORY", goldColor,
                onTap: () => Get.to(() => const OrderHistoryScreen())),
            const SizedBox(height: 10),
            _menuItem(Icons.star, "REVIEW CENTRE", goldColor,
                onTap: () => Get.to(() => const ReviewsPage())),
            const SizedBox(height: 10),
            _menuItem(Icons.help_outline, "HELP CENTER", goldColor,
                subtitle: "Call us at 555-333-222",
                onTap: () => Get.to(() => const CustomerSupportScreen())),
          ],
        ),
      ),
    );
  }

  Widget _editableTextField({
    required TextEditingController controller,
    required String label,
    required Color goldColor,
    required bool isEditing,
  }) {
    return isEditing
        ? TextField(
            controller: controller,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              labelText: label,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: goldColor),
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Text(
                  "$label: ",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
                Expanded(
                  child: Text(
                    controller.text.isEmpty ? "Not set" : controller.text,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
  }

  Widget _menuItem(IconData icon, String title, Color color,
      {String? subtitle, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: 15)),
                  if (subtitle != null)
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
