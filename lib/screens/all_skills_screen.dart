import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import 'booking/booking_discover_screen.dart';

class AllSkillsScreen extends StatelessWidget {
  const AllSkillsScreen({super.key});

  final List<Map<String, dynamic>> skills = const [
    {'title': 'Photographer', 'icon': Icons.camera_alt_rounded, 'color': Color(0xFFFFEBEE)},
    {'title': 'Videographer', 'icon': Icons.videocam_rounded, 'color': Color(0xFFE3F2FD)},
    {'title': 'Influencer', 'icon': Icons.star_rounded, 'color': Color(0xFFF3E5F5)},
    {'title': 'Editor', 'icon': Icons.auto_fix_high_rounded, 'color': Color(0xFFE8F5E9)},
    {'title': 'Drone Pilot', 'icon': Icons.airplanemode_active_rounded, 'color': Color(0xFFFFF3E0)},
    {'title': 'Stylist', 'icon': Icons.style_rounded, 'color': Color(0xFFFCE4EC)},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Professional Skills',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : const Color(0xFF1A1A1A), size: 18),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(25),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 0.9,
        ),
        itemCount: skills.length,
        itemBuilder: (context, index) {
          final skill = skills[index];
          return FadeInUp(
            delay: Duration(milliseconds: 100 * index),
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingDiscoverScreen(initialSkill: skill['title']))),
              child: Container(
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 10))
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(color: skill['color'], borderRadius: BorderRadius.circular(25)),
                      child: Icon(skill['icon'], color: const Color(0xFF1A1A1A), size: 32),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      skill['title'],
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 15, color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
