import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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

                // ✨ Welcome Title
                Text(
                  'Welcome to the Home Screen!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.amberAccent,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                // ✨ Subtitle Text
                Text(
                  'You’ve successfully logged in.\nEnjoy your experience!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // 🟨 Info Card
                Card(
                  color: Colors.black,
                  elevation: 8,
                  shadowColor: Colors.amberAccent.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.amberAccent, width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.home,
                          color: Colors.amberAccent,
                          size: 50,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'This is your personalized Home screen.\nAll set to explore!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.amberAccent,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 50),

                // 🟡 Logout or Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Add your navigation or logout logic here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amberAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ⚙️ Floating Action Button (gold accent)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your FAB action
        },
        backgroundColor: Colors.amberAccent,
        child: Icon(
          Icons.arrow_forward,
          color: Colors.black,
        ),
      ),
    );
  }
}

