import 'package:flutter/material.dart';
import 'package:aman_play/screens/start_page.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {

    Future.delayed(const Duration(seconds: 3), () {
     Get.off(() => const StartPage());
    });
    
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7F3),
      body: Stack(
        children: [
          // 1. Top right circle
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset('assets/images/TopC.png', width: 150),
          ),

          // 2. Buttom left circle
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset('assets/images/BottomC.png', width: 150),
          ),

          // 3. AmanPlay Logo
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/AmanPlayLOGO.png', width: 280),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
