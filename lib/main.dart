import 'package:flutter/material.dart';
import 'package:todo/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app',
      theme: ThemeData(fontFamily: 'IndieFlower'),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
