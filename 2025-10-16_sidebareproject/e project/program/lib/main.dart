import 'package:flutter/material.dart';
import 'profile_sidebar.dart';
import 'pages/profile_page.dart';
import 'pages/search_page.dart';
import 'pages/cart_page.dart';
import 'pages/wishlist_page.dart';
import 'pages/customer_service_page.dart';
import 'pages/logout_page.dart';

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
        primaryColor: Colors.amber,
      ),
      routes: {
        '/profile': (context) => const ProfilePage(),
        '/search': (context) => const SearchPage(),
        '/cart': (context) => const CartPage(),
        '/wishlist': (context) => const WishlistPage(),
        '/customerService': (context) => const CustomerServicePage(),
        '/logout': (context) => const LogoutPage(),
      },
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('WatchHub', style: TextStyle(color: Colors.amber)),
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      drawer: const ProfileSidebar(),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'Welcome to WatchHub!',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}
