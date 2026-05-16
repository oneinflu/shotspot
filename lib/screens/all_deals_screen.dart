import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/combo_card.dart';
import 'combo_selection_screen.dart';

class AllDealsScreen extends StatelessWidget {
  const AllDealsScreen({super.key});

  final List<Map<String, dynamic>> deals = const [
    {
      'title': 'Wedding Special:\nPhoto + Video',
      'price': '\u20B924,999',
      'image': 'assets/images/combo_photo_video.png',
      'color': Color(0xFFE91E63)
    },
    {
      'title': 'Content Creator:\nEdit + Music',
      'price': '\u20B94,999',
      'image': 'assets/images/skill_editing.png',
      'color': Color(0xFF2196F3)
    },
    {
      'title': 'Drone Mastery:\nAerial + Ground',
      'price': '\u20B912,499',
      'image': 'assets/images/banner.png',
      'color': Color(0xFF4CAF50)
    },
    {
      'title': 'Birthday Blast:\nFull Coverage',
      'price': '\u20B98,999',
      'image': 'assets/images/package_wedding.png',
      'color': Color(0xFFFF9800)
    },
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
          'Exclusive Deals',
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
      body: ListView.builder(
        padding: const EdgeInsets.all(25),
        itemCount: deals.length,
        itemBuilder: (context, index) {
          final deal = deals[index];
          return FadeInUp(
            delay: Duration(milliseconds: 150 * index),
            child: Container(
              height: 220,
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 25),
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComboSelectionScreen())),
                child: Hero(
                  tag: 'deal_${index}',
                  child: ComboCard(
                    title: deal['title'],
                    price: deal['price'],
                    imagePath: deal['image'],
                    accentColor: deal['color'],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
