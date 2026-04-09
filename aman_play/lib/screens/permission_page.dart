import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

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
     WidgetsBinding.instance.addPostFrameCallback((_) {  _showPermissionDialog();
    });
  } 

  void _showPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('يرجى منح الإذن'),
          content: Text('يحتاج أمان بلاي إلى استخدام الميكروفون لكي يستطيع تسجيل المدخلات الصوتية'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                print("تستطيع منح الإذن لاحقًا");
              },
              child: Text("لاحقًا"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _handleConfirm();
              },
              child: Text("موافق")
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

   @override
  
  Widget build(BuildContext context) {
  return const Scaffold(
    body: SizedBox.shrink(), // empty screen
  );
}
} 