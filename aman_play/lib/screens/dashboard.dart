import 'package:flutter/material.dart';
import 'detection.dart';

void main() {
  runApp(const dashboard());
}

class dashboard extends StatelessWidget {
  const dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF00C9A7)),
        useMaterial3: true,
        fontFamily: 'Cairo', // Arabic-friendly font
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 2; // Dashboard tab selected by default

  // Sample weekly data for audio statistics
  final List<double> audioData = [14, 25, 22, 16, 15, 17, 20];

  // Sample weekly data for writing statistics
  final List<double> writingData = [12, 20, 18, 8, 13, 15, 17];

  final List<String> weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            // Header
            _buildHeader(),

            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  children: [
                    _buildChartCard(
                      title: 'الاحصائيات الصوتية',
                      data: audioData,
                    ),
                    const SizedBox(height: 16),
                    _buildChartCard(
                      title: 'الاحصائيات الكتابية',
                      data: writingData,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6DD5A0),
            Color(0xFF2EC4A7),
            Color(0xFF00A896),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Decorative blob shape top-left
          Positioned(
            top: -30,
            left: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Decorative blob bottom-right
          Positioned(
            bottom: -20,
            right: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Greeting text (RTL: appears on the right)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'اهلاً،',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'وجد الخميس',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // Avatar
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withOpacity(0.6), width: 2),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({required String title, required List<double> data}) {
    final double maxVal = data.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Title row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Edit button (left side in RTL = left)
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'تعديل',
                  style: TextStyle(
                    color: Color(0xFF00A896),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF222222),
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          // Subtitle
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'نسب النشر المرصودة خلال الأسبوع',
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF999999),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Bar Chart
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(data.length, (index) {
                return _buildBar(
                  value: data[index],
                  maxValue: maxVal,
                  label: weekDays[index],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar({
    required double value,
    required double maxValue,
    required String label,
  }) {
    const double maxBarHeight = 80.0;
    final double barHeight = (value / maxValue) * maxBarHeight;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Value label on top of bar
        Text(
          value.toInt().toString(),
          style: const TextStyle(
            fontSize: 9,
            color: Color(0xFF666666),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 3),
        // Bar
        AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          width: 26,
          height: barHeight,
          decoration: BoxDecoration(
            color: const Color(0xFF00C9A7),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        // Day label
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF999999),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFFF5EDD5),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(icon: Icons.settings_outlined, index: 0),
          _buildNavItem(icon: Icons.headphones_outlined, index: 1),
          _buildNavItem(icon: Icons.bar_chart_rounded, index: 2),
        ],
      ),
    );
  }

  Widget _buildNavItem({required IconData icon, required int index}) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () async {
        if (index == 1) {
          // Navigate to Detection page
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DetectionScreen()),
          );
          // Reset to dashboard tab when returning
          setState(() => _selectedIndex = 2);
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00C9A7).withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF00A896) : const Color(0xFF888888),
          size: 26,
        ),
      ),
    );
  }
}