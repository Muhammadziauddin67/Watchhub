// import 'package:flutter/material.dart';
// import 'package:app/screens/screen1.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Screen1(),
//     );
//   }
// }

// void main(){
//   runApp(
//     MyApp(
//     )
//   );
// }
import 'package:flutter/material.dart';
import 'screens/main-screens/customersupport-feedback.dart';
import 'screens/main-screens/order-history.dart';
import 'screens/main-screens/wishlist.dart';

void main() {
  runApp(const WatchHubApp());
}



class WatchHubApp extends StatelessWidget {
  const WatchHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WatchHub',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A1A1A),
        fontFamily: 'Poppins',
        primaryColor: const Color(0xFFD4AF37), // Gold tone
      ),
      home: const WishlistScreen(),
      routes: {
        '/support': (_) => const CustomerSupportScreen(),
        '/orders': (_) => const OrderHistoryScreen(),
        '/wishlist': (_) => const WishlistScreen(),
      },
    );
  }
}