import 'package:flutter/material.dart';
import 'detection2.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  bool _isToggled = false;

  void _onToggleChanged(bool value) async {
    setState(() => _isToggled = value);

    if (value) {
      // Navigate to detection2
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Detection2Screen()),
      );
      // Reset toggle when returning
      setState(() => _isToggled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF7F5),
        body: Stack(
          children: [
            // Background decorative shapes
            _buildBackground(),

            // Content
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back arrow
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF555555),
                        size: 24,
                      ),
                    ),
                  ),

                  // Center card
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: _buildToggleCard(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        // Top-right large teal circle (partially visible)
        Positioned(
          top: -60,
          right: -60,
          child: Container(
            width: 260,
            height: 260,
            decoration: const BoxDecoration(
              color: Color(0xFFB2E4DC),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Top-right white circle overlap
        Positioned(
          top: -20,
          right: 60,
          child: Container(
            width: 180,
            height: 180,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF7F5),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Bottom-left teal circle
        Positioned(
          bottom: -60,
          left: -60,
          child: Container(
            width: 240,
            height: 240,
            decoration: const BoxDecoration(
              color: Color(0xFFB2E4DC),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Bottom-left white circle overlap
        Positioned(
          bottom: -20,
          left: 60,
          child: Container(
            width: 160,
            height: 160,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF7F5),
              shape: BoxShape.circle,
            ),
          ),
        ),
        // Decorative gold ring bottom-left area
        Positioned(
          bottom: 80,
          left: -40,
          child: Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFD4B88A).withOpacity(0.5),
                width: 2,
              ),
            ),
          ),
        ),
        // Decorative gold ring top-right area
        Positioned(
          top: 80,
          right: -40,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFD4B88A).withOpacity(0.5),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFD6F0EC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label
          const Text(
            'بدء عملية الكشف عن التنمر',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222222),
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 16),
          // Toggle switch
          Transform.scale(
            scale: 1.3,
            child: Switch(
              value: _isToggled,
              onChanged: _onToggleChanged,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF4A6E6A),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFF4A6E6A),
            ),
          ),
        ],
      ),
    );
  }
}