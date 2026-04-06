import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main(){
  runApp(const AmanPlayApp());
}

class AmanPlayApp extends StatelessWidget {
  const AmanPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AmanPlay',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Cairo',
      ),
      home: const SplashScreen(),
    );
  }
}