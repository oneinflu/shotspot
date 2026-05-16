import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Methods', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Saved Cards', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            FadeInLeft(child: _buildCreditCard('•••• •••• •••• 4582', 'Sarah Jenkins', '12/26', const Color(0xFF1A1A1A))),
            const SizedBox(height: 15),
            FadeInRight(child: _buildCreditCard('•••• •••• •••• 9901', 'Sarah Jenkins', '05/25', const Color(0xFFE91E63))),
            const SizedBox(height: 30),
            Text('UPI / Other', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet_rounded),
              title: const Text('Google Pay / PhonePe'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            const Spacer(),
            Container(
              width: double.infinity, height: 56,
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE91E63)), borderRadius: BorderRadius.circular(18)),
              child: Center(child: Text('+ Add New Method', style: GoogleFonts.plusJakartaSans(color: const Color(0xFFE91E63), fontWeight: FontWeight.w800))),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCard(String number, String name, String expiry, Color color) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(25), boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 10))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.credit_card, color: Colors.white, size: 30),
          const SizedBox(height: 30),
          Text(number, style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 2)),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('CARD HOLDER', style: TextStyle(color: Colors.white54, fontSize: 10)), Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('EXPIRES', style: TextStyle(color: Colors.white54, fontSize: 10)), Text(expiry, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]),
            ],
          )
        ],
      ),
    );
  }
}
