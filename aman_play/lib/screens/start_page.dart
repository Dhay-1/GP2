import 'package:flutter/material.dart';
import 'package:aman_play/screens/login_page.dart';
import 'package:aman_play/screens/sign_up_page.dart';
import 'package:aman_play/widgets/custom_button.dart';
import 'package:get/get.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2FDFB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. AmanPlay Logo
              Image.asset('assets/images/AmanPlayLOGO.png', width: 250),
              const SizedBox(height: 10),
              const Text(
                'AMAN Play',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00BFA5),
                ),
              ),
              const SizedBox(height: 50),

              // 2. Login Button
              CustomButton(
                text: 'تسجيل دخول',
                color: const Color(0xFF00BFA5),
                onPressed: () {
                  Get.to(() => const LoginPage());
                  print("Login Clicked");
                },
              ),

              const SizedBox(height: 15),

              // 3. Sign Up Button
              CustomButton(
                text: 'إنشاء حساب',
                color: const Color(0xFF00BFA5),
                textColor: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Get.to(() => const SignUpPage());
                  print("Sign Up Clicked");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
