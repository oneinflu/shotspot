import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class PerformanceScreen extends StatelessWidget {
  const PerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Analytics', style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.w900)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatGrid(),
            const SizedBox(height: 35),
            Text('Booking Trends', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 20),
            _buildTrendsChart(),
            const SizedBox(height: 35),
            _buildDetailedStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.4,
      children: [
        _statBox('Total Views', '12.4K', Icons.visibility_outlined, Colors.blue),
        _statBox('Conversion', '8.2%', Icons.sync_alt_rounded, Colors.purple),
        _statBox('Avg. Rating', '4.9', Icons.star_outline_rounded, Colors.orange),
        _statBox('Response', '2h', Icons.timer_outlined, Colors.green),
      ],
    );
  }

  Widget _statBox(String l, String v, IconData i, Color c) {
    return FadeInUp(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(i, color: c, size: 20),
            const SizedBox(height: 10),
            Text(v, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 18)),
            Text(l, style: TextStyle(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendsChart() {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(35),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(6, (index) => Container(
          width: 30,
          height: (40 + (index * 20)).toDouble(),
          decoration: BoxDecoration(
            color: index == 4 ? const Color(0xFFE91E63) : Colors.white10,
            borderRadius: BorderRadius.circular(8),
          ),
        )),
      ),
    );
  }

  Widget _buildDetailedStats() {
    return Column(
      children: [
        _detailRow('Profile Completeness', '95%', Colors.green),
        _detailRow('On-time Arrival', '98%', Colors.blue),
        _detailRow('Customer Satisfaction', '4.9/5', Colors.orange),
      ],
    );
  }

  Widget _detailRow(String l, String v, Color c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          Text(v, style: TextStyle(color: c, fontWeight: FontWeight.w900, fontSize: 14)),
        ],
      ),
    );
  }
}
