import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aman_play/widgets/custom_button.dart';
import 'package:aman_play/screens/permission_page.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context){
    return Directionality(
      textDirection: TextDirection.rtl, 
      child: Scaffold(
        backgroundColor: const Color(0xFFF2FDFB),
        appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: const BackButton(color: Colors.black)),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(Icons.mark_email_read_outlined, size: 100, color: Color(0xFF00BFA5)),
              const SizedBox(height: 30),
              const Text(
                "تحقق من بريدك الإلكتروني",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "لقد أرسلنا كود التحقق إلى بريدك. يرجى إدخاله في الأسفل.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              Directionality(
              textDirection: TextDirection.ltr,

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _otpBox(context),
                  _otpBox(context),
                  _otpBox(context),
                  _otpBox(context),
                ],
              ),
              ),
              const SizedBox(height: 40),

              CustomButton(
                text: "تحقق", 
                color: const Color(0xFF00BFA5), 
                onPressed: (){
                Get.to(()=> const PermissionPage());

                },
                ),
                TextButton(onPressed: (){}, 
                child: const Text("لم يصلك الكود؟ إعادة إرسال"),
                ),
            ],
          ),
          ),
      ),
      );
  }
  Widget _otpBox(BuildContext context){
    return SizedBox(
      width: 80,
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF00BFA5))
          ),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus(); // ينقل المربع للي بعده
          } else if (value.isEmpty){
            FocusScope.of(context).previousFocus();
          }
        },
      ),

    );
  }
}