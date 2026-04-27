import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';

class Detection2Screen extends StatefulWidget {
  const Detection2Screen({super.key});

  @override
  State<Detection2Screen> createState() => _Detection2ScreenState();
}

class _Detection2ScreenState extends State<Detection2Screen> {
  bool _isRecording = false;
  String? _recordedFilePath;
  final AudioRecorder _recorder = AudioRecorder();
  final TextEditingController _textController = TextEditingController();

  // ── Text analysis state ──────────────────────────────────────────────────────
  bool _isAnalyzing = false;
  String? _analysisResult;

  // ── Output path ──────────────────────────────────────────────────────────────
  Future<String> _getOutputPath() async {
    final dir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/recording_$timestamp.m4a';
  }

  // ── Start recording ──────────────────────────────────────────────────────────
  // No permission requests here — already handled in PermissionPage
  Future<void> _startRecording() async {
    if (!await _recorder.hasPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'لم يتم منح إذن الميكروفون.',
              style: TextStyle(fontFamily: 'Cairo'),
            ),
          ),
        );
      }
      return;
    }

    final path = await _getOutputPath();

    await _recorder.start(
      RecordConfig(
        encoder: AudioEncoder.aacLc,
        bitRate: 128000,
        sampleRate: 44100,
      ),
      path: path,
    );

    setState(() {
      _isRecording = true;
      _recordedFilePath = path;
    });
  }

  // ── Stop recording ───────────────────────────────────────────────────────────
  Future<void> _stopRecording() async {
    final path = await _recorder.stop();
    setState(() {
      _isRecording = false;
      _recordedFilePath = path;
    });

    if (path != null) {
      debugPrint('Recording saved to: $path');
      // TODO: send `path` to your audio bullying-detection API
    }
  }

  // ── Toggle recording ─────────────────────────────────────────────────────────
  void _toggleRecording() {
    if (_isRecording) {
      _stopRecording();
    } else {
      _startRecording();
    }
  }

  // ── Text analysis ────────────────────────────────────────────────────────────
  Future<void> _analyzeText() async {
    final text = _textController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى كتابة نص للتحليل.',
            style: TextStyle(fontFamily: 'Cairo'),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _analysisResult = null;
    });

    try {
      // TODO: Replace with your actual API call
   

      // ── Simulated response (remove when API is ready) ──
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _analysisResult = 'لا يوجد تنمر'; // placeholder result
      });
      // ──────────────────────────────────────────────────
    } catch (e) {
      setState(() {
        _analysisResult = 'حدث خطأ أثناء التحليل.';
      });
    } finally {
      setState(() => _isAnalyzing = false);
    }
  }

  @override
  void dispose() {
    _recorder.dispose();
    _textController.dispose();
    super.dispose();
  }

  // ── Build ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF7F5),
        body: Stack(
          children: [
            _buildBackground(),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 12, left: 16, right: 16),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF555555),
                        size: 24,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildAudioCard(),
                            const SizedBox(height: 20),
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
                        ? BorderRadius.circular(4)
                        : BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
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
          if (_recordedFilePath != null && !_isRecording) ...[
            const SizedBox(height: 6),
            Text(
              'تم الحفظ: ${_recordedFilePath!.split('/').last}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFF888888),
                fontFamily: 'Cairo',
              ),
            ),
          ],
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
              onPressed: _isAnalyzing ? null : _analyzeText,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A896),
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    const Color(0xFF00A896).withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: _isAnalyzing
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'تحليل النص',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
            ),
          ),

          // Analysis result
          if (_analysisResult != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _analysisResult == 'لا يوجد تنمر'
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _analysisResult == 'لا يوجد تنمر'
                      ? Colors.green.withOpacity(0.4)
                      : Colors.red.withOpacity(0.4),
                ),
              ),
              child: Text(
                _analysisResult!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                  color: _analysisResult == 'لا يوجد تنمر'
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}