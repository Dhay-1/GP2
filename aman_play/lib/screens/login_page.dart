import 'package:flutter/material.dart';
import 'package:aman_play/screens/sign_up_page.dart';
import 'package:aman_play/screens/forget_password_page.dart';
import 'package:aman_play/widgets/custom_button.dart';
import 'package:aman_play/screens/Verification_page.dart';
import 'package:get/get.dart';


class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,

      child: Scaffold(
        backgroundColor: const Color(0xFFF2FDFB),

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: BackButton(color: Colors.black),
        ),
        
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 80),

                // 1. AmanPlay Logo
                Image.asset('assets/images/AmanPlayLOGO.png', width: 120),
                const SizedBox(height: 40),

                const Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF00BFA5),
                  ),
                ),

                const SizedBox(height: 30),

                // 2. Email Field
                TextField(
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // 3. Password Field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    //1. On the right Forget Password
                    TextButton(
                      onPressed: () {
                        Get.to(() => const ForgetPasswordPage());
                      },
                      child: const Text(
                        "نسيت كلمة المرور؟",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),

                    //2. on the left Create Account
                    TextButton(
                      onPressed: () {
                        Get.to(() =>  SignUpPage());
                      },

                      child: const Text(
                        "إنشاء حساب جديد",
                        style: TextStyle(
                          color: Color(0xFF00BFA5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // 4. Login Button
                CustomButton(
                  text: "دخول",
                  color: const Color(0xFF00BFA5),
                  onPressed: () {
                    // Add Authenaction Code Here
                    Get.to(() => const VerificationPage());
                   

                    print("Login pressed");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
