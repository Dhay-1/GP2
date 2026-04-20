import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:aman_play/widgets/custom_button.dart';
import 'package:aman_play/screens/permission_page.dart';
import 'package:aman_play/services/auth_service.dart';
import 'dart:async';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final AuthService authService = Get.find<AuthService>();
  Timer? _timer;
  Timer? _countdownTimer;
  int _resendCountdown = 0;
  bool isEmailVerified = false;

  @override
  void initState() {
    super.initState();
    _startCheckingEmailVerification();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCheckingEmailVerification() {
    // Check every 3 seconds if email is verified
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await authService.reloadUser();
      
      if (authService.isEmailVerified) {
        _timer?.cancel();
        if (!mounted) return;
        setState(() {
          isEmailVerified = true;
        });
        
        Get.snackbar(
          'تم التحقق',
          'تم تحقق بريدك الإلكتروني بنجاح!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        
        if (!mounted) return;
      }
    });
  }

  Future<void> _resendVerificationEmail() async {
    await authService.resendVerificationEmail();
    
    if (authService.errorMessage.value.isEmpty) {
      Get.snackbar(
        'تم الإرسال',
        'تم إرسال بريد التحقق مرة أخرى',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      // Start countdown
      setState(() {
        _resendCountdown = 60;
      });
      
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() {
          _resendCountdown--;
        });
        if (_resendCountdown == 0) {
          timer.cancel();
        }
      });
    } else {
      Get.snackbar(
        'خطأ',
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
          leading: const BackButton(color: Colors.black),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isEmailVerified ? Icons.verified : Icons.mark_email_read_outlined,
                size: 100,
                color: isEmailVerified ? Colors.green : const Color(0xFF00BFA5),
              ),
              const SizedBox(height: 30),
              Text(
                isEmailVerified ? "تم التحقق بنجاح" : "تحقق من بريدك الإلكتروني",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                isEmailVerified
                    ? "تم التحقق من بريدك الإلكتروني بنجاح!"
                    : "لقد أرسلنا بريد تحقق إلى:\n${authService.userEmail}",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 40),

              CustomButton(
                text: "تحقق", 
                color: const Color(0xFF00BFA5), 
                onPressed: (){
                Get.to(()=> const PermissionPage());

                },
              if (!isEmailVerified)
                Column(
                  children: [
                    const Text(
                      "الرجاء الضغط على الرابط في البريد للتحقق",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 10),
                    const CircularProgressIndicator(
                      color: Color(0xFF00BFA5),
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      text: _resendCountdown > 0
                          ? "إعادة إرسال (${_resendCountdown}s)"
                          : "لم يصلك البريد؟ إعادة إرسال",
                      color: _resendCountdown > 0
                          ? Colors.grey
                          : const Color(0xFF00BFA5),
                      onPressed: _resendCountdown == 0
                          ? _resendVerificationEmail
                          : () {}, 
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Get.snackbar(
                          'تنبيه',
                          'يمكنك الاستمرار بدون تحقق البريد',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        if (mounted) {
                          Get.back();
                        }
                      },
                      child: const Text(
                        "المتابعة بدون تحقق (للاختبار فقط)",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              if (isEmailVerified)
                Column(
                  children: [
                    const SizedBox(height: 20),
                    const Icon(Icons.check_circle, color: Colors.green, size: 50),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "المتابعة",
                      color: const Color(0xFF00BFA5),
                      onPressed: () {
                        if (mounted) {
                          Get.back();
                        }
                      },
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}