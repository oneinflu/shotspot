import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Client Reviews', style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.w900)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(25),
        physics: const BouncingScrollPhysics(),
        itemCount: 6,
        itemBuilder: (context, index) => _buildReviewCard(index),
      ),
    );
  }

  Widget _buildReviewCard(int index) {
    return FadeInUp(
      delay: Duration(milliseconds: 100 * index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFFE91E63).withOpacity(0.1),
                  child: Text(['RS', 'AK', 'MP', 'JD', 'KL', 'ST'][index], style: const TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Rahul Sharma', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                      Text('July ${28 - index}, 2026', style: TextStyle(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
                Row(
                  children: List.generate(5, (i) => Icon(Icons.star_rounded, color: i < 5 ? Colors.orange : Colors.grey[300], size: 16)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Alex was incredible! The photos from our wedding are beyond what we imagined. Highly recommended for any premium events.',
              style: TextStyle(color: Colors.grey[700], fontSize: 13, height: 1.5, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _tag('Wedding'),
                const SizedBox(width: 10),
                _tag('Cinematic'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String l) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
      child: Text(l, style: TextStyle(color: Colors.grey[600], fontSize: 10, fontWeight: FontWeight.w800)),
    );
  }
}
