import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/booking_provider.dart';
import 'professional_selection_screen.dart';

class BookingDiscoverScreen extends StatefulWidget {
  final String? initialEvent;
  final String? initialSkill;
  const BookingDiscoverScreen({super.key, this.initialEvent, this.initialSkill});

  @override
  State<BookingDiscoverScreen> createState() => _BookingDiscoverScreenState();
}

class _BookingDiscoverScreenState extends State<BookingDiscoverScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).fetchEventTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final bookingProvider = Provider.of<BookingProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFBFBFB),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 80, 25, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeInLeft(
                    child: Text(
                      'Event\nPlanning', 
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 40, 
                        fontWeight: FontWeight.w900, 
                        letterSpacing: -2.0, 
                        height: 1.0,
                        color: isDark ? Colors.white : Colors.black,
                      )
                    )
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Select an event to find the perfect professional', 
                    style: TextStyle(color: Colors.grey[500], fontSize: 16)
                  ),
                ],
              ),
            ),
          ),
          bookingProvider.isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: Color(0xFFE91E63))),
                )
              : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final event = bookingProvider.eventTypes[index];
                        return FadeInUp(
                          delay: Duration(milliseconds: 100 * index),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.02),
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  )
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    bookingProvider.selectEvent(event);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProfessionalSelectionScreen(eventType: event['title']),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(24),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                                    child: Row(
                                      children: [
                                        Container(
                                          height: 54,
                                          width: 54,
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE91E63).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          child: Image.network(
                                            event['image'],
                                            color: const Color(0xFFE91E63), // Tinting the icon with app color
                                            errorBuilder: (context, error, stackTrace) => const Icon(Icons.event_available_rounded, color: Color(0xFFE91E63)),
                                          ),
                                        ),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                event['title'],
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w800,
                                                  color: isDark ? Colors.white : Colors.black,
                                                ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'View available professionals',
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            color: isDark ? Colors.white54 : Colors.black26,
                                            size: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: bookingProvider.eventTypes.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
