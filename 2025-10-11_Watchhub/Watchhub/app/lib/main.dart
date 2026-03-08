import 'package:flutter/material.dart';
import 'package:app/screens/screen1.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Screen1(),
    );
  }
}

void main(){
  runApp(
    MyApp(
    )
  );
}