import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:app/auth/auth.dart';
import 'package:app/screens/main-screens/login-screen.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();

  Authant auth = Authant();

  bool decision = true;
  bool decisions = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔸 Clock Logo
                Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.amberAccent, width: 2),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Minute hand
                      Transform.rotate(
                        angle: -0.6,
                        child: Container(
                          height: 40,
                          width: 2,
                          color: Colors.amberAccent,
                        ),
                      ),
                      // Hour hand
                      Transform.rotate(
                        angle: 1.0,
                        child: Container(
                          height: 25,
                          width: 2,
                          color: Colors.amberAccent,
                        ),
                      ),
                      // Center dot
                      Container(
                        height: 8,
                        width: 8,
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                // ✉️ Email Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email",
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // ✉️ Email Field
                TextField(
                  controller: usernameController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.amberAccent, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // 🔒 Password Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Password",
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 🔒 Password Field
                TextField(
                  controller: passwordController,
                  obscureText: decision,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          decision = !decision;
                        });
                      },
                      icon: Icon(
                        decision ? Icons.visibility_off : Icons.visibility,
                        color: Colors.amberAccent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.amberAccent, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // 🔐 Confirm Password Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Confirm Password",
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 🔐 Confirm Password Field
                TextField(
                  controller: confirmpasswordController,
                  obscureText: decisions,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          decisions = !decisions;
                        });
                      },
                      icon: Icon(
                        decisions ? Icons.visibility_off : Icons.visibility,
                        color: Colors.amberAccent,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.amberAccent, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 35),

                // 🟨 Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (passwordController.text ==
                          confirmpasswordController.text) {
                        auth.signUp(
                            usernameController.text, passwordController.text);
                      } else {
                        print("Password and confirm password don't match");
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),

                // 🔸 Already Have Account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an Account?",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Get.to(Login());
                      },
                      child: Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.amberAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
