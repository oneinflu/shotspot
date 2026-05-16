import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'bookings_screen.dart';
import 'earnings_screen.dart';
import 'bank_details_screen.dart';
import 'performance_screen.dart';
import 'reviews_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildWelcomeHeader(),
                      const SizedBox(height: 25),
                      _buildEarningsCard(),
                      const SizedBox(height: 35),
                      _buildSectionTitle('Active Schedule'),
                      const SizedBox(height: 15),
                      _buildNextShootCard(context),
                      const SizedBox(height: 35),
                      _buildSectionTitle('Tools & Services'),
                      const SizedBox(height: 15),
                      _buildQuickActions(context),
                      const SizedBox(height: 120), // Space for bottom padding
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildFloatingNavBar(context),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color(0xFFFBFBFB),
      elevation: 0,
      pinned: true,
      leadingWidth: 80,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Center(
          child: Container(
            height: 45, width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE91E63), width: 2),
              image: const DecorationImage(image: AssetImage('assets/images/top_viewed_1.png'), fit: BoxFit.cover),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: Stack(
            children: [
              const Icon(Icons.notifications_none_rounded, color: Colors.black, size: 28),
              Positioned(
                right: 4, top: 4,
                child: Container(height: 8, width: 8, decoration: const BoxDecoration(color: Color(0xFFE91E63), shape: BoxShape.circle)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  Widget _buildWelcomeHeader() {
    return FadeInLeft(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome back,', style: TextStyle(color: Colors.grey[500], fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Alex Thompson', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w900, color: const Color(0xFF1A1A1A))),
        ],
      ),
    );
  }

  Widget _buildEarningsCard() {
    return FadeInDown(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 25, offset: const Offset(0, 15))],
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1A1A), Color(0xFF2D2D2D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Earnings', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text('\u20B984,250', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                  child: const Text('+12% vs last mo', style: TextStyle(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                _miniStat('Pending', '\u20B912,400', Colors.orange),
                const SizedBox(width: 35),
                _miniStat('Withdrawn', '\u20B962,000', Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(height: 6, width: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return FadeIn(
      child: Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900, color: const Color(0xFF1A1A1A))),
    );
  }

  Widget _buildNextShootCard(BuildContext context) {
    return FadeInRight(
      child: GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingsScreen())),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 160,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
                      image: const DecorationImage(image: AssetImage('assets/images/package_wedding.png'), fit: BoxFit.cover),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15, left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFE91E63), borderRadius: BorderRadius.circular(10)),
                      child: const Text('UPCOMING TODAY', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('The Royal Wedding', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w900)),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on_rounded, size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text('Fairmont Hotel, Jaipur', style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 50, width: 50,
                          decoration: BoxDecoration(color: const Color(0xFFE91E63).withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                          child: const Icon(Icons.directions_rounded, color: Color(0xFFE91E63)),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _shootInfo(Icons.access_time_rounded, '02:00 PM', '8 Hour Session'),
                        _shootInfo(Icons.videocam_rounded, 'Lead Video', 'Cinematography'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shootInfo(IconData i, String t, String s) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
          child: Icon(i, size: 18, color: const Color(0xFF1A1A1A)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
            Text(s, style: TextStyle(color: Colors.grey[500], fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _actionBtn(Icons.calendar_month_rounded, 'Availability', 'Set your free slots', const Color(0xFFE91E63), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingsScreen())))),
            const SizedBox(width: 15),
            Expanded(child: _actionBtn(Icons.account_balance_wallet_rounded, 'Payouts', 'Withdraw your money', Colors.green, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EarningsScreen())))),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: _actionBtn(Icons.analytics_outlined, 'Performance', 'View your stats', Colors.blue, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PerformanceScreen())))),
            const SizedBox(width: 15),
            Expanded(child: _actionBtn(Icons.star_outline_rounded, 'Reviews', 'Client feedback', Colors.orange, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ReviewsScreen())))),
          ],
        ),
      ],
    );
  }

  Widget _actionBtn(IconData i, String t, String s, Color c, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(i, color: c, size: 22),
            ),
            const SizedBox(height: 15),
            Text(t, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 14)),
            const SizedBox(height: 4),
            Text(s, style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavBar(BuildContext context) {
    return Positioned(
      bottom: 30, left: 20, right: 20,
      child: FadeInUp(
        child: Container(
          height: 75,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(35),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navIcon(Icons.home_filled, true),
              _navIcon(Icons.calendar_today_rounded, false, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BookingsScreen()))),
              _navIcon(Icons.wallet_rounded, false, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EarningsScreen()))),
              _navIcon(Icons.person_outline_rounded, false, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BankDetailsScreen()))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData i, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(i, color: isActive ? const Color(0xFFE91E63) : Colors.white54, size: 28),
          if (isActive) 
            Container(margin: const EdgeInsets.only(top: 4), height: 4, width: 4, decoration: const BoxDecoration(color: Color(0xFFE91E63), shape: BoxShape.circle)),
        ],
      ),
    );
  }
}
