import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/screens/main-screens/home.dart';
import 'package:app/screens/main-screens/login-screen.dart';
import 'package:app/admin-screens.dart/dashboard.dart';

class Authant extends GetxController {
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🧑‍💼 Your hardcoded super admin email
  static const String superAdminEmail = "admin@watchhub.com";

  User? get currentUser => _auth.currentUser;

  // ✅ SIGN UP
  Future<void> signUp(String emailP, String passwordP) async {
    try {
      // 1️⃣ Create Auth account
      UserCredential userCred = await _auth.createUserWithEmailAndPassword(
        email: emailP,
        password: passwordP,
      );

      // 2️⃣ Decide role (super admin or normal user)
      String role = (emailP == superAdminEmail) ? "admin" : "user";

      // 3️⃣ Create Firestore user profile with all required fields
      await _firestore.collection("users").doc(userCred.user!.uid).set({
        "name": "",
        "email": emailP,
        "phone": "",
        "profilePic": "",
        "role": role,
        "address": {
          "street": "",
          "city": "",
          "postalCode": "",
          "country": "",
        },
        "wishlist": [],
        "cart": [],
        "orders": [], // ✅ Optional: can also use subcollection later
      });

      Get.snackbar(
        "Account Created",
        "Please log in to continue",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Redirect to login
      Get.offAll(() => Login());
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Sign Up Failed",
        e.message ?? "Unknown error occurred",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // ✅ SIGN IN
  Future<void> signIn(String emailP, String passwordP) async {
    try {
      UserCredential cred = await _auth.signInWithEmailAndPassword(
        email: emailP,
        password: passwordP,
      );

      // Fetch Firestore user data
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(cred.user!.uid).get();

      // If Firestore doc doesn't exist (safety fallback)
      if (!userDoc.exists) {
        await _firestore.collection("users").doc(cred.user!.uid).set({
          "name": "",
          "email": emailP,
          "phone": "",
          "profilePic": "",
          "role": "user",
          "address": {
            "street": "",
            "city": "",
            "postalCode": "",
            "country": "",
          },
          "wishlist": [],
          "cart": [],
          "orders": [],
        });
      }

      // Get role
      final role = userDoc.exists ? userDoc['role'] : "user";

      // Redirect to correct dashboard
      if (role == "admin" || emailP == superAdminEmail) {
        Get.offAll(() => const AdminDashboard());
      } else {
        Get.offAll(() => Home());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Failed",
        e.message ?? "Incorrect credentials",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // ✅ RESET PASSWORD
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "Password Reset Email Sent",
        "Check your inbox at $email",
        backgroundColor: Colors.amberAccent,
        colorText: Colors.black,
      );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Error",
        e.message ?? "Unable to send reset email",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // ✅ SIGN OUT
  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAll(() => Login());
  }
}
