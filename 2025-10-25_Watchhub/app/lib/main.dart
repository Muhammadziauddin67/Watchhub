import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app/controllers/order_controller.dart';
import 'firebase_options.dart';

// 🔹 Screens
import 'package:app/screens/main-screens/home.dart';
import 'package:app/screens/main-screens/login-screen.dart';
import 'package:app/screens/main-screens/shopping-cart.dart';
import 'package:app/screens/main-screens/product-details.dart';
import 'package:app/screens/main-screens/order-confirmation.dart';
import 'package:app/screens/main-screens/checkout-step01.dart';
import 'package:app/screens/main-screens/checkout-step02.dart';
import 'package:app/screens/main-screens/checkout-step03.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  Get.put(OrderController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WatchHub',
      theme: ThemeData(
        primaryColor: const Color(0xFFD4AF37),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFFD4AF37),
          secondary: Colors.black,
        ),
      ),
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const WatchhubSplash()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/home', page: () => const Home()),
        GetPage(name: '/cart', page: () => const CartPage()),
        GetPage(
          name: '/product-details',
          page: () {
            final args = Get.arguments;
            if (args == null || args is! Map<String, dynamic>) {
              return const Scaffold(
                body: Center(child: Text('Error: No product data found')),
              );
            }
            return ProductDetailsPage(product: args);
          },
        ),
        GetPage(name: '/checkout-step1', page: () => const CheckoutStep1Page()),
        GetPage(name: '/checkout-step2', page: () => const CheckoutStep2()),
        GetPage(name: '/checkout-step3', page: () => const CheckoutStep3Page()),
        GetPage(name: '/orders', page: () => OrdersPage()),
      ],
    );
  }
}

/// ✅ Custom Splash Screen
class WatchhubSplash extends StatefulWidget {
  const WatchhubSplash({super.key});

  @override
  State<WatchhubSplash> createState() => _WatchhubSplashState();
}

class _WatchhubSplashState extends State<WatchhubSplash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed('/login'); // Navigate to login after splash
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(size: const Size(100, 100), painter: ClockPainter()),
            const SizedBox(width: 20),
            const Text(
              'WatchHub',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🕒 Clock Animation Painter
class ClockPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final circlePaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = const Color(0xFFD4A95D);

    final hourHandPaint = Paint()
      ..color = const Color(0xFFD4A95D)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final minuteHandPaint = Paint()
      ..color = const Color(0xFFD4A95D)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Outer circle
    canvas.drawCircle(center, radius, circlePaint);

    // Hour hand (2 o'clock)
    final hourX = center.dx + radius * 0.5;
    final hourY = center.dy;
    canvas.drawLine(center, Offset(hourX, hourY), hourHandPaint);

    // Minute hand (11 o'clock)
    final minuteX = center.dx - radius * 0.3;
    final minuteY = center.dy - radius * 0.8;
    canvas.drawLine(center, Offset(minuteX, minuteY), minuteHandPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
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