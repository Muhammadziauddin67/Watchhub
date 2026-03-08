import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/screens/main-screens/home.dart';
import 'package:app/screens/main-screens/login-screen.dart';

class Authant {
  final FirebaseAuth ourobject = FirebaseAuth.instance;

  Future<void> signUp(String emailP, String passwordP) async {
    try {
      await ourobject.createUserWithEmailAndPassword(
          email: emailP, password: passwordP);
      Get.off(Login());
    } catch (e) {
      print(e.toString());
      Get.snackbar("Error", e.toString(),
          backgroundColor: Color.fromARGB(255, 255, 0, 0),
          colorText: Color.fromARGB(255, 255, 255, 255));
    }
  }

  Future<void> signIn(String emailP, String passwordP) async {
    try {
      await ourobject.signInWithEmailAndPassword(
          email: emailP, password: passwordP);
      Get.off(Home());
    } catch (e) {
      print(e.toString());
      Get.snackbar("Error", e.toString(),
          backgroundColor: Color.fromARGB(255, 255, 0, 0),
          colorText: Color.fromARGB(255, 255, 255, 255));
    }
  }



  
// 🔹 Reset Password
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      print("✅ Password reset email sent to $email");
    } on FirebaseAuthException catch (e) {
      print("❌ Error: ${e.message}");
      rethrow;
    }
  }
}