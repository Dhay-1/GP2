import 'package:flutter/material.dart';

class Detection extends StatefulWidget {
  const Detection({super.key});

  @override
  State<Detection> createState() => _DetectionState();
}

class _DetectionState extends State<Detection> {
  bool firstSwitchValue = false;

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          // Text
          Text(
            "إبدأ عملية الكشف",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 20), // spacing

          // Switch
          Switch(
            value: firstSwitchValue,
            onChanged: (value) {
              setState(() {
                firstSwitchValue = value;
              });
            },
          ),

        ],
      ),
    ),
  );
} }