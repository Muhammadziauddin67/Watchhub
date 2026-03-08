import 'package:flutter/material.dart';

class Screen1 extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image(
          image: AssetImage('Images/logo/Watchhub-Logo.png'),
        ),
        ),
    );
  }
}