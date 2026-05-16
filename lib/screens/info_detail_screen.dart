import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InfoDetailScreen extends StatelessWidget {
  final String title;
  const InfoDetailScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Last updated: April 2026', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
            const SizedBox(height: 25),
            _buildSection('1. Introduction', 'Welcome to ShotSpot. We value your trust and are committed to protecting your personal information. This document outlines how we handle your data and our services.'),
            _buildSection('2. Service Usage', 'Our platform allows you to book professional photographers and videographers. All bookings are subject to availability and service area restrictions.'),
            _buildSection('3. Payments & Fees', 'Payments are processed securely. Refund policies vary based on the specific package and timing of cancellation.'),
            _buildSection('4. Content Rights', 'Customers retain rights to their photos, while ShotSpot and creators may use them for portfolio purposes unless otherwise specified.'),
            _buildSection('5. Support', 'For any queries, please reach out via our Help Center or contact our 24/7 support line.'),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFFE91E63))),
          const SizedBox(height: 10),
          Text(content, style: GoogleFonts.plusJakartaSans(fontSize: 14, height: 1.6, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
