import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Search', style: TextStyle(color: Colors.amber)),
        iconTheme: const IconThemeData(color: Colors.amber),
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: Text(
          'This is Search page.',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}
