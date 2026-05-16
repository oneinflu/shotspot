import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/section_header.dart';
import '../widgets/shot_card.dart';

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: FadeInLeft(
              child: Text(
                'Saved\nMoments',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.1,
                  letterSpacing: -1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),
          const SectionHeader(title: 'Recent Favorites', actionLabel: 'Manage'),
          const SizedBox(height: 20),
          _buildSavedGrid(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildSavedGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 15,
          crossAxisSpacing: 15,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          return FadeInUp(
            delay: Duration(milliseconds: 100 * index),
            child: ShotCard(
              index: index,
              imagePath: index % 2 == 0 ? 'assets/images/top_viewed_1.png' : 'assets/images/top_viewed_2.png',
              author: '@creator_${index + 1}',
              title: 'Saved Aesthetic ${index + 1}',
            ),
          );
        },
      ),
    );
  }
}
