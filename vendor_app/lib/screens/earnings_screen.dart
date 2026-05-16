import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Wallet & Payouts', style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.w900)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceHero(),
            const SizedBox(height: 40),
            _buildSectionHeader('Weekly Activity'),
            const SizedBox(height: 20),
            _buildWeeklyChart(),
            const SizedBox(height: 40),
            _buildSectionHeader('Recent Payouts'),
            const SizedBox(height: 20),
            _buildTransactionsList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String t) {
    return Text(t, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900));
  }

  Widget _buildBalanceHero() {
    return FadeInDown(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(35),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [BoxShadow(color: const Color(0xFFE91E63).withOpacity(0.2), blurRadius: 30, offset: const Offset(0, 15))],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10)),
              child: const Text('AVAILABLE BALANCE', style: TextStyle(color: Colors.white60, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
            ),
            const SizedBox(height: 15),
            Text('\u20B928,450', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 42, fontWeight: FontWeight.w900)),
            const SizedBox(height: 35),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(color: const Color(0xFFE91E63), borderRadius: BorderRadius.circular(18)),
                      child: const Center(child: Text('Withdraw', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900))),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  height: 55, width: 55,
                  decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(18)),
                  child: const Icon(Icons.history_rounded, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart() {
    final List<double> values = [0.4, 0.7, 0.5, 0.9, 0.3, 0.8, 0.6];
    return FadeInUp(
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(values.length, (index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 12,
                  height: 100 * values[index],
                  decoration: BoxDecoration(
                    color: index == 3 ? const Color(0xFFE91E63) : const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 12),
                Text(['M', 'T', 'W', 'T', 'F', 'S', 'S'][index], style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTransactionsList() {
    return Column(
      children: List.generate(4, (index) => _transactionItem(index)),
    );
  }

  Widget _transactionItem(int index) {
    bool isCredit = index != 1;
    return FadeInUp(
      delay: Duration(milliseconds: 100 * index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Container(
              height: 50, width: 50,
              decoration: BoxDecoration(color: (isCredit ? Colors.green : Colors.blue).withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
              child: Icon(isCredit ? Icons.add_rounded : Icons.account_balance_rounded, color: isCredit ? Colors.green : Colors.blue),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isCredit ? 'Wedding Shoot Payment' : 'Bank Withdrawal', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text('Jul ${28 - index} • ID: #882$index', style: TextStyle(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${isCredit ? "+" : "-"}\u20B9${isCredit ? "4,999" : "10,000"}', style: TextStyle(color: isCredit ? Colors.green : Colors.black, fontWeight: FontWeight.w900, fontSize: 16)),
                Text(isCredit ? 'Success' : 'Processing', style: TextStyle(color: isCredit ? Colors.green.withOpacity(0.5) : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
