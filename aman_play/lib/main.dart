import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';

void main() async {
  // This line is required to talk to the native Android code
  WidgetsFlutterBinding.ensureInitialized();
  
  // This starts Firebase
  await Firebase.initializeApp();
  print("Firebase is ready!");
  
  // Initialize Auth Service
  Get.put(AuthService());
  
  runApp(const AmanPlayApp());
}

class AmanPlayApp extends StatelessWidget {
  const AmanPlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
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