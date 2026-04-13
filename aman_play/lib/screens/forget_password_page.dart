import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aman_play/widgets/custom_button.dart';

class ForgetPasswordPage extends StatelessWidget {
  const ForgetPasswordPage({super.key});

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
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.lock_reset, size: 100, color: Color(0xFF00BFA5)),
              const SizedBox(height: 30),
              const Text(
                "نسيت كلمة المرور؟",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                "أدخل بريدك الإلكتروني وسنرسل لك رابط لاعادة تعيين كلمة المرور الخاصة بك.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 40),

              TextField(
                decoration: InputDecoration(
                  labelText: '',
                  suffixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              CustomButton(
                text: "إرسال الرابط",
                color: const Color(0xFF00BFA5),
                onPressed: () {
                  //FireBase Code Here
                  Get.snackbar(
                    "يرجى التحقق من بريدك الإلكتروني",
                    "تم الإرسال",
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
