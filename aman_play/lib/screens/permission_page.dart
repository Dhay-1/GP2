import 'package:flutter/material.dart';
import 'permission_page2.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});
 
  @override
  _PermissionPageState createState() => _PermissionPageState();
}
 
class _PermissionPageState extends State<PermissionPage> {
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
          content: const Text(
              'يحتاج أمان بلاي إلى استخدام الميكروفون لكي يستطيع تسجيل المدخلات الصوتية'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                _goToNextPage();        // navigate regardless
              },
              child: const Text("لاحقًا", style: TextStyle(color: Colors.teal)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                _handleConfirm();
                _goToNextPage();        // navigate after confirming
              },
              child: const Text("موافق", style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }
 
  void _handleConfirm() {
    // Handle the logic for confirming permission here
    print("تم منح الإذن، يمكنك الآن استخدام الميكروفون");
  }
 
  void _goToNextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PermissionPage2()),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox.shrink(), // empty screen
    );
  }
}
 