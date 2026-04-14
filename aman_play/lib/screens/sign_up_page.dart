import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aman_play/widgets/custom_button.dart';
import 'package:aman_play/services/auth_service.dart';
import 'Verification_page.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final AuthService authService = Get.find<AuthService>();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final fullName = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    // Call Firebase Auth sign up
    await authService.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );

    // Check for errors
    if (authService.errorMessage.value.isEmpty) {
      // Success - navigate to verification page
      Get.offAll(() => const VerificationPage());
    } else {
      // Show error
      Get.snackbar(
        'خطأ في إنشاء الحساب',
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  Image.asset('assets/images/AmanPlayLOGO.png', width: 100),
                  const SizedBox(height: 30),

                  const Text(
                    "إنشاء حساب جديد",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00BFA5),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 1. Name Field
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'الاسم الكامل',
                      prefixIcon: const Icon(Icons.person_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسمك الكامل';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // 2. Email Field
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      if (!value.contains('@')) {
                        return 'الرجاء إدخال بريد إلكتروني صالح';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // 3. Password Field
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      helperText: 'يجب أن تكون 6 أحرف على الأقل',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
                      }
                      if (value.length < 6) {
                        return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  // 4. Password confirmation
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'تأكيد كلمة المرور',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء تأكيد كلمة المرور';
                      }
                      if (value != passwordController.text) {
                        return 'كلمات المرور غير متطابقة';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // 5. SignUp Button with Loading State
                  Obx(
                    () => authService.isLoading.value
                        ? const CircularProgressIndicator(
                            color: Color(0xFF00BFA5),
                          )
                        : CustomButton(
                            text: "إنشاء حساب",
                            color: const Color(0xFF00BFA5),
                            onPressed: _handleSignUp,
                          ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text(
                      "لديك حساب بالفعل؟ سجل دخولك",
                      style: TextStyle(color: Color(0xFF00BFA5)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

