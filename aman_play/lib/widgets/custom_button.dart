import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback onPressed;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.textColor = Colors.white,
    this.icon,
 });

 @override
 Widget build(BuildContext context){
  return ElevatedButton(
    onPressed: onPressed, 
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      minimumSize: const Size(double.infinity, 55),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if(icon != null) ...[
          Icon(icon, color: textColor),
          const SizedBox(width: 10),
        ],
        Text(
          text,
          style: TextStyle(color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
          ),
        ),
      ],
    ),
  );
 }
}