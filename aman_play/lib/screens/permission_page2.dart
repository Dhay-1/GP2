import 'package:flutter/material.dart';

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
          content: Text('يحتاج أمان بلاي إلي إرسال إشعارات مع كل عملية رصد'),
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