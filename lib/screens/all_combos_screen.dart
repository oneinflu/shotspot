import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/home_provider.dart';
import '../widgets/combo_card.dart';
import 'combo_config_screen.dart';

class AllCombosScreen extends StatelessWidget {
  const AllCombosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final homeProvider = Provider.of<HomeProvider>(context);
    final combos = homeProvider.combos;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Exclusive Combos',
          style: GoogleFonts.plusJakartaSans(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.w900,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black,
            size: 20,
          ),
        ),
      ),
      body: combos.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.auto_awesome_motion_rounded, size: 80, color: Colors.grey[300]),
                  const SizedBox(height: 20),
                  Text(
                    'No combos found',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 200,
                mainAxisSpacing: 20,
              ),
              itemCount: combos.length,
              itemBuilder: (context, index) {
                final combo = combos[index];
                return FadeInUp(
                  delay: Duration(milliseconds: 100 * index),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ComboConfigScreen()),
                    ),
                    child: ComboCard(
                      title: combo['name'],
                      price: '\u20B9${combo['price']}',
                      imagePath: combo['image'],
                      accentColor: index % 2 == 0 ? const Color(0xFFE91E63) : const Color(0xFF2196F3),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
