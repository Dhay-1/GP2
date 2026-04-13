import 'package:flutter/material.dart';
import 'dashboard.dart';

class PermissionPage2 extends StatefulWidget {
  const PermissionPage2({super.key});

  @override
  _PermissionPageState2 createState() => _PermissionPageState2();
}

class _PermissionPageState2 extends State<PermissionPage2> {
  @override
  void initState() {
    super.initState();

    // Show the permission dialog after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showPermissionDialog();
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'يرجى منح الإذن',
            textAlign: TextAlign.center,
          ),
          content: const Text('يحتاج أمان بلاي إلي إرسال إشعارات مع كل عملية رصد'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                _goToDashboard();       // navigate regardless
              },
              child: const Text("لاحقًا", style: TextStyle(color: Colors.teal)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                _handleConfirm();
                _goToDashboard();       // navigate after confirming
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
              ),
              child: const Text("موافق", style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

  void _handleConfirm() {
    print("تم منح الإذن، يمكنك الآن استخدام الميكروفون");
  }

  void _goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.shrink(), // empty screen
    );
  }
}