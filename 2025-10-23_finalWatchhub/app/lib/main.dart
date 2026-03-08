import 'package:app/screens/main-screens/login-screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:Login(),
    );
  }
}

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


// class WatchHubApp extends StatelessWidget {
//   const WatchHubApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'WatchHub',
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color(0xFF1A1A1A),
//         fontFamily: 'Poppins',
//         primaryColor: const Color(0xFFD4AF37), // Gold tone
//       ),
//       home: Signup(),
//       routes: {
//         '/support': (_) => const CustomerSupportScreen(),
//         '/orders': (_) => const OrderHistoryScreen(),
//         '/wishlist': (_) => const WishlistScreen(),
//         '/admins-dash' : (_) => const AdminDashboard(),
//         '/profile' : (_) => const ProfilePage(),
//         'cart' : (_) => const CartPage(),
//         'signup' : (_) =>  Signup(),
//       },
//     );
//   }
// }