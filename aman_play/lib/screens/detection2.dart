import 'package:flutter/material.dart';

class Detection2Screen extends StatefulWidget {
  const Detection2Screen({super.key});

  @override
  State<Detection2Screen> createState() => _Detection2ScreenState();
}

class _Detection2ScreenState extends State<Detection2Screen> {
  bool _isRecording = false;
  final TextEditingController _textController = TextEditingController();

  void _toggleRecording() {
    setState(() => _isRecording = !_isRecording);
    // TODO: Hook up actual mic recording logic here
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF7F5),
        body: Stack(
          children: [
            // Background decorative shapes (same as detection.dart)
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

                  // Cards
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Audio detection card
                            _buildAudioCard(),
                            const SizedBox(height: 20),
                            // Text detection card
                            _buildTextCard(),
                          ],
                        ),
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
        // Top-right large teal circle
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
        // Decorative gold ring bottom-left
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
        // Decorative gold ring top-right
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

  Widget _buildAudioCard() {
    return Container(
      width: double.infinity,
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
        children: [
          // Title
          const Text(
            'كشف التنمر الصوتي',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222222),
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 16),
          // Record button
          GestureDetector(
            onTap: _toggleRecording,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF00A896),
                  width: 3,
                ),
                color: _isRecording
                    ? const Color(0xFF00A896).withOpacity(0.15)
                    : Colors.white,
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isRecording ? 20 : 24,
                  height: _isRecording ? 20 : 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A896),
                    borderRadius: _isRecording
                        ? BorderRadius.circular(4) // square = stop icon
                        : BorderRadius.circular(12), // circle = record icon
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Recording status hint
          Text(
            _isRecording ? 'جارٍ التسجيل... اضغط للإيقاف' : 'اضغط للتسجيل',
            style: TextStyle(
              fontSize: 11,
              color: _isRecording
                  ? const Color(0xFF00A896)
                  : const Color(0xFF999999),
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextCard() {
    return Container(
      width: double.infinity,
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
        children: [
          // Title
          const Text(
            'كشف التنمر الكتابي',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF222222),
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 14),
          // Text input field
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _textController,
              textDirection: TextDirection.rtl,
              maxLines: 3,
              style: const TextStyle(
                fontSize: 13,
                fontFamily: 'Cairo',
                color: Color(0xFF333333),
              ),
              decoration: const InputDecoration(
                hintText: 'اكتب النص هنا...',
                hintStyle: TextStyle(
                  color: Color(0xFFBBBBBB),
                  fontSize: 13,
                  fontFamily: 'Cairo',
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Analyse button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Hook up text analysis logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A896),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: const Text(
                'تحليل النص',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}