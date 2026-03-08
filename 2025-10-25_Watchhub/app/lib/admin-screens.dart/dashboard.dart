import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app/admin-screens.dart/product-management.dart';
import 'package:app/admin-screens.dart/user-management.dart';
import 'package:app/admin-screens.dart/order-management.dart';
import 'package:app/admin-screens.dart/reviews-management.dart';

const Color primaryWhite = Colors.white;
const Color secondaryBlack = Colors.black;
const Color accentGold = Color(0xFFFFD700);

class AdminDashboard extends StatefulWidget {
const AdminDashboard({super.key});

@override
State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
int _selectedIndex = 0;

final List<Widget> _screens = const [
ProductManagementScreen(),
UserManagementScreen(),
OrderManagementScreen(),
ReviewManagementScreen(),
];

final List<String> _titles = [
'Product Management',
'User Management',
'Order Management',
'Review Management',
];

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: primaryWhite,
appBar: AppBar(
backgroundColor: primaryWhite,
title: Text(
_titles[_selectedIndex],
style: const TextStyle(
color: secondaryBlack,
fontWeight: FontWeight.bold,
),
),
iconTheme: const IconThemeData(color: secondaryBlack),
elevation: 2,
),
drawer: Drawer(
backgroundColor: primaryWhite,
child: Column(
children: [
DrawerHeader(
decoration: const BoxDecoration(color: accentGold),
child: Center(
child: Text(
'WatchHub Admin',
style: TextStyle(
color: secondaryBlack,
fontSize: 20,
fontWeight: FontWeight.bold,
),
),
),
),
Expanded(
child: ListView(
children: [
_buildDrawerItem(Icons.watch, 'Product Management', 0),
_buildDrawerItem(Icons.people, 'User Management', 1),
_buildDrawerItem(Icons.shopping_cart, 'Order Management', 2),
_buildDrawerItem(Icons.reviews, 'Review Management', 3),
],
),
),
const Divider(),
Padding(
padding: const EdgeInsets.symmetric(vertical: 8.0),
child: ListTile(
leading: const Icon(Icons.logout, color: Colors.red),
title: const Text(
'Sign Out',
style: TextStyle(
color: Colors.red,
fontWeight: FontWeight.bold,
),
),
onTap: () async {
await FirebaseAuth.instance.signOut();
if (context.mounted) {
Navigator.of(context).pushReplacementNamed('/login');
}
},
),
),
],
),
),
body: _screens[_selectedIndex],
);
}

Widget _buildDrawerItem(IconData icon, String title, int index) {
final bool isSelected = _selectedIndex == index;
return ListTile(
leading: Icon(icon, color: isSelected ? accentGold : secondaryBlack),
title: Text(
title,
style: TextStyle(
color: isSelected ? accentGold : secondaryBlack,
fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
),
),
onTap: () {
setState(() {
_selectedIndex = index;
});
Navigator.pop(context);
},
);
}
}