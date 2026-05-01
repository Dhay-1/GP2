import 'package:aman_play/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart'; 
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';


class Detection2Screen extends StatefulWidget {
  const Detection2Screen({super.key});

  @override
  State<Detection2Screen> createState() => _Detection2ScreenState();
}

class _Detection2ScreenState extends State<Detection2Screen> {
  bool _isRecording = false;
  final TextEditingController _textController = TextEditingController();
  AudioRecorder? _audioRecorder;
  
  
  final String _baseUrl = "http://192.168.0.174:8000"; 
  final String _userEmail =  FirebaseAuth.instance.currentUser?.email ?? ""; // Get users email from the Firebase Auth

  // --- AUDIO LOGIC ---
 void _toggleRecording() async {
  if (_isRecording) {
    // STOP
    final path = await _audioRecorder?.stop();
    await _audioRecorder?.dispose();
    _audioRecorder = null;  // clean up
    setState(() => _isRecording = false);

    if (path != null) {
      _showLoadingDialog("جاري تحليل الصوت...");
      await _sendAudioToAI(path);
    }
  } else {
    // create a fresh recorder
    _audioRecorder = AudioRecorder();
    
    
    final hasPermission = await _audioRecorder!.hasPermission();
    print(">>> Microphone permission: $hasPermission");  
    
    if (hasPermission) {
      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/recording.wav';
      print(">>> Saving to: $path");  
      
      await _audioRecorder!.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: path,
      );
      setState(() => _isRecording = true);
    } else {
      print(">>> NO MICROPHONE PERMISSION!");
    }
  }
}
Future<void> _sendAudioToAI(String filePath) async {
  var request = http.MultipartRequest('POST', Uri.parse('$_baseUrl/predict/audio'));
  request.files.add(await http.MultipartFile.fromPath('file', filePath));
  request.fields['user_email'] = _userEmail;

  var response = await request.send();
  
  if (response.statusCode == 200) {
    // ✅ Read stream only once
    final responseBody = await response.stream.bytesToString();
    var data = jsonDecode(responseBody);

    // Save to Firestore only if bullying detected
    if (data['is_bullying'] == true) {
      await FirestoreService.instance.saveDetectionResult(
        userEmail: _userEmail,
        isBullying: data['is_bullying'],
        confidence: data['confidence'],
        transcription: data['transcription'],
        source: "audio",
      );
    }

    if (mounted) Navigator.pop(context); // close loading dialog

    _showResultDialog(
      data['is_bullying'] == true ? "Bullying" : "Not Bullying",
      data['transcription'],
    );
  } else {
    if (mounted) Navigator.pop(context);
    _showResultDialog("خطأ", "فشل الاتصال بالخادم");
  }
}
  // --- TEXT LOGIC ---
 Future<void> _analyzeText() async {
  String text = _textController.text.trim();
  if (text.isEmpty) return;

  _showLoadingDialog("جاري تحليل النص...");

 Navigator.pop(context); 
final response = await http.post(
  Uri.parse('$_baseUrl/predict/text'),
  headers: {
    "Content-Type": "application/json; charset=UTF-8",
    "Accept": "application/json",
  },
  body: jsonEncode({'text': text, 'user_email': _userEmail}),
);
if (response.statusCode == 200) {
  var data = jsonDecode(response.body);
  _showResultDialog(
    data['is_bullying'] ? "Bullying" : "Not Bullying",
    data['transcription'],
  );
/// if bullying is detected will save the result to fire base 
 if (data['is_bullying'] == true) {
    await FirestoreService.instance.saveDetectionResult(
      userEmail: _userEmail,
      isBullying: data['is_bullying'],
      confidence: data['confidence'],
      transcription: data['transcription'],
      source: "text",
    );
 if (mounted) Navigator.pop(context);

  _showResultDialog(
    data['is_bullying'] == true ? "Bullying" : "Not Bullying",
    data['transcription'],
  );
}
 } 
 }
  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Color(0xFF00A896)),
            const SizedBox(height: 16),
            Text(message, style: const TextStyle(fontFamily: 'Cairo')),
          ],
        ),
      ),
    );
  }

  void _showResultDialog(String label, String content) {
    bool isBullying = label == "Bullying";
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isBullying ? "تنبيه: تم رصد تنمر" : "النص سليم", 
            textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Cairo')),
        content: Text(content, textAlign: TextAlign.center),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("موافق"))
        ],
      ),
    );
  }

 @override
void dispose() {
  _textController.dispose();
  _audioRecorder?.dispose();  
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
                _analyzeText();
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