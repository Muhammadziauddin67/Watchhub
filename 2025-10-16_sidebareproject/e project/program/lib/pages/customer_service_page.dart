import 'package:flutter/material.dart';

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Text('Customer Service',
            style: TextStyle(color: Colors.amber)),
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'This is Customer Service page.',
          style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 18),
        ),
      ),
    );
  }
}
