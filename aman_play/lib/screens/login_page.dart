import 'package:flutter/material.dart';
import 'package:aman_play/screens/sign_up_page.dart';
import 'package:aman_play/screens/forget_password.dart';
import 'package:aman_play/widgets/custom_button.dart';
import 'package:aman_play/screens/Verification_page.dart';
import 'package:aman_play/services/auth_service.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final AuthService authService = Get.find<AuthService>();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Validation
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'خطأ',
        'الرجاء إدخال البريد الإلكتروني وكلمة المرور',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!email.contains('@')) {
      Get.snackbar(
        'خطأ',
        'البريد الإلكتروني غير صالح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Call login
    await authService.login(email: email, password: password);

    // Check for errors
    if (authService.errorMessage.value.isEmpty) {
      // Success - navigate to verification page
      Get.offAll(() => const VerificationPage());
    } else {
      // Show error
      Get.snackbar(
        'خطأ في تسجيل الدخول',
        authService.errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

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
                  controller: emailController,
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
                  controller: passwordController,
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
                    // Forget Password
                    TextButton(
                      onPressed: () {
                        Get.to(() => const ForgetPasswordPage());
                      },
                      child: const Text(
                        "نسيت كلمة المرور؟",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),

                    // Create Account
                    TextButton(
                      onPressed: () {
                        Get.to(() => SignUpPage());
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

                // 4. Login Button with Loading State
                Obx(
                  () => authService.isLoading.value
                      ? const CircularProgressIndicator(
                          color: Color(0xFF00BFA5),
                        )
                      : CustomButton(
                          text: "دخول",
                          color: const Color(0xFF00BFA5),
                          onPressed: _handleLogin,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
