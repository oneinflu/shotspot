import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('My Schedule', style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.w900)),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
          ),
          bottom: TabBar(
            indicatorColor: const Color(0xFFE91E63),
            indicatorWeight: 4,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: const Color(0xFF1A1A1A),
            unselectedLabelColor: Colors.grey[400],
            labelStyle: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 14),
            tabs: const [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: const TabBarView(
          physics: BouncingScrollPhysics(),
          children: [
            _ShootList(isUpcoming: true),
            _ShootList(isUpcoming: false),
          ],
        ),
      ),
    );
  }
}

class _ShootList extends StatelessWidget {
  final bool isUpcoming;
  const _ShootList({required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
      physics: const BouncingScrollPhysics(),
      itemCount: isUpcoming ? 3 : 8,
      itemBuilder: (context, index) => _ShootCard(index: index, isUpcoming: isUpcoming),
    );
  }
}

class _ShootCard extends StatelessWidget {
  final int index;
  final bool isUpcoming;
  const _ShootCard({required this.index, required this.isUpcoming});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      delay: Duration(milliseconds: 100 * index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    height: 70, width: 70,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      image: DecorationImage(
                        image: AssetImage(index % 2 == 0 ? 'assets/images/package_wedding.png' : 'assets/images/combo_photo_video.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(index % 2 == 0 ? 'Royal Wedding' : 'Cinematic Portfolio', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 16)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.person_rounded, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('Client: Rahul S.', style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _statusBadge(isUpcoming),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: const Color(0xFFFBFBFB), borderRadius: BorderRadius.circular(25)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoItem(Icons.calendar_month_rounded, 'July 28, 2026'),
                  _infoItem(Icons.access_time_rounded, '10:00 AM'),
                  _infoItem(Icons.currency_rupee_rounded, '4,999'),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(bool upcoming) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: (upcoming ? const Color(0xFFE91E63) : Colors.green).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
      child: Text(upcoming ? 'CONFIRMED' : 'PAID', style: TextStyle(color: upcoming ? const Color(0xFFE91E63) : Colors.green, fontSize: 10, fontWeight: FontWeight.w900)),
    );
  }

  Widget _infoItem(IconData i, String t) {
    return Row(
      children: [
        Icon(i, size: 14, color: const Color(0xFF1A1A1A).withOpacity(0.5)),
        const SizedBox(width: 6),
        Text(t, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11)),
      ],
    );
  }
}
