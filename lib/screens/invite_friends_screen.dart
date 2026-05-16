import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';

class InviteFriendsScreen extends StatelessWidget {
  const InviteFriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Invite Friends', style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.w900)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: [
            _buildIllustration(),
            const SizedBox(height: 40),
            _buildReferralCard(context),
            const SizedBox(height: 40),
            _buildShareOptions(),
            const SizedBox(height: 50),
            _buildHowItWorks(),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return FadeInDown(
      child: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63).withOpacity(0.05),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  top: -20, right: -20,
                  child: CircleAvatar(radius: 50, backgroundColor: const Color(0xFFE91E63).withOpacity(0.1)),
                ),
                const Icon(Icons.group_add_rounded, size: 80, color: Color(0xFFE91E63)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text('Invite your Friends', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1)),
          const SizedBox(height: 8),
          Text('Share the joy of professional shots with\nyour friends and family.', 
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 14, height: 1.5, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildReferralCard(BuildContext context) {
    const code = "SHOT500";
    return FadeInUp(
      delay: const Duration(milliseconds: 200),
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
          border: Border.all(color: Colors.black.withOpacity(0.02)),
        ),
        child: Column(
          children: [
            Text('YOUR REFERRAL CODE', style: TextStyle(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1.5)),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(code, style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w900, color: const Color(0xFF1A1A1A))),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(const ClipboardData(text: code));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Code Copied!'), behavior: SnackBarBehavior.floating, backgroundColor: Color(0xFFE91E63)));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: const Color(0xFFE91E63).withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
                    child: const Icon(Icons.copy_rounded, color: Color(0xFFE91E63), size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShareOptions() {
    return FadeInUp(
      delay: const Duration(milliseconds: 300),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _shareIcon(Icons.chat_rounded, 'WhatsApp', const Color(0xFF25D366)),
          _shareIcon(Icons.camera_alt_outlined, 'Instagram', const Color(0xFFE4405F)),
          _shareIcon(Icons.send_rounded, 'Telegram', const Color(0xFF0088CC)),
          _shareIcon(Icons.more_horiz_rounded, 'More', Colors.grey[700]!),
        ],
      ),
    );
  }

  Widget _shareIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          height: 60, width: 60,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 10),
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.grey)),
      ],
    );
  }

  Widget _buildHowItWorks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('How it works', style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900)),
        const SizedBox(height: 25),
        _stepItem('1', 'Share your code', 'Send your referral code to your friends.'),
        _stepItem('2', 'Friend joins ShotSpot', 'They enter your code during their first booking.'),
        _stepItem('3', 'Enjoy the shots', 'Capture beautiful moments together.'),
      ],
    );
  }

  Widget _stepItem(String num, String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 35, width: 35,
            decoration: BoxDecoration(color: const Color(0xFFE91E63), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(num, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 4),
                Text(sub, style: TextStyle(color: Colors.grey[500], fontSize: 13, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


