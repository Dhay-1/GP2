import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aman_play/widgets/custom_button.dart';
import 'Verification_page.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
                    decoration: InputDecoration(
                      labelText: 'البريد الإلكتروني',
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || !value.contains('@')) 
                        return 'الرجاء إدخال بريد إلكتروني صالح';
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
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال كلمة المرور';
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
                      } else if (value != passwordController.text) {
                        return 'كلمات المرور غير متطابقة';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // 5. SignUp Button
                  CustomButton(
                    text: "إنشاء حساب",
                    color: const Color(0xFF00BFA5),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {

                        //FireBase Code Here
                        Get.off(() => const VerificationPage());
                      } else {
                         print("");
                      }
                      print("Sign Up pressed");
                    },
                  ),

                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("لديك حساب بالفعل؟ سجل دخولك"),
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
