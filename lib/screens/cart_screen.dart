import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import 'booking/payment_flow_screens.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isAdvancePayment = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFBFBFB),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(context, isDark),
            _buildProgressIndicator(isDark),
            Expanded(
              child: cart.items.isEmpty
                  ? _buildEmptyState(isDark)
                  : _buildCartList(cart, isDark),
            ),
            if (cart.items.isNotEmpty) _buildSummarySection(cart, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          if (Navigator.canPop(context)) ...[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: isDark ? Colors.white10 : Colors.white, shape: BoxShape.circle, boxShadow: [if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
                child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
              ),
            ),
            const SizedBox(width: 20),
          ],
          Text('Booking Summary', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _stepItem('Cart', true, true),
          Expanded(child: Container(height: 2, color: const Color(0xFFE91E63))),
          _stepItem('Payment', false, false),
          Expanded(child: Container(height: 2, color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05))),
          _stepItem('Success', false, false),
        ],
      ),
    );
  }

  Widget _stepItem(String label, bool isDone, bool isActive) {
    return Column(
      children: [
        Container(
          height: 30, width: 30,
          decoration: BoxDecoration(
            color: isDone ? const Color(0xFFE91E63) : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(color: isDone || isActive ? const Color(0xFFE91E63) : Colors.grey[300]!, width: 2),
          ),
          child: isDone ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: isDone || isActive ? FontWeight.bold : FontWeight.w500, color: isDone || isActive ? const Color(0xFFE91E63) : Colors.grey)),
      ],
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(color: const Color(0xFFE91E63).withOpacity(0.05), shape: BoxShape.circle),
            child: Icon(Icons.shopping_bag_outlined, size: 80, color: const Color(0xFFE91E63).withOpacity(0.5)),
          ),
          const SizedBox(height: 30),
          Text('No Bookings Found', style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          Text('Your cart is currently empty.\nExplore professionals to start your journey.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[500], fontSize: 15, height: 1.5)),
        ],
      ),
    );
  }

  Widget _buildCartList(CartProvider cart, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items[index];
        return FadeInRight(
          delay: Duration(milliseconds: 100 * index),
          child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 70, width: 70,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), image: DecorationImage(image: NetworkImage(item.image), fit: BoxFit.cover)),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: const Color(0xFFE91E63).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                            child: Text(item.role, style: const TextStyle(color: Color(0xFFE91E63), fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => cart.removeFromCart(item.id),
                      icon: Icon(Icons.close_rounded, color: Colors.grey[400]),
                    ),
                  ],
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1, color: Colors.black12)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoItem(Icons.calendar_today_rounded, DateFormat('d MMM').format(item.date)),
                    _infoItem(Icons.access_time_rounded, item.time),
                    _infoItem(Icons.history_rounded, '${item.hours}h'),
                    Text(item.price, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 15)),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _infoItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[400]),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSummarySection(CartProvider cart, bool isDark) {
    final total = cart.totalAmount;
    final advanceAmount = total * 0.3;
    final payableAmount = _isAdvancePayment ? advanceAmount : total;

    return Container(
      padding: const EdgeInsets.fromLTRB(30, 20, 30, 110), // Added 110 bottom for nav bar clearance
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, -10))],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Expanded(child: _paymentOption('Full Payment', !_isAdvancePayment, isDark, () => setState(() => _isAdvancePayment = false))),
                  Expanded(child: _paymentOption('30% Advance', _isAdvancePayment, isDark, () => setState(() => _isAdvancePayment = true))),
                ],
              ),
            ),
            const SizedBox(height: 25),
            _summaryRow('Base Professional Fees', '\u20B9${total.toInt()}', isDark),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Professional Fees', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 18)),
                Text('\u20B9${payableAmount.toInt()}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 24, color: const Color(0xFFE91E63))),
              ],
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentProcessingScreen(amount: payableAmount)));
              },
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 10))],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 12),
                      Text('Proceed to Payment', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentOption(String title, bool isSelected, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: isSelected ? (isDark ? Colors.white10 : Colors.white) : Colors.transparent, borderRadius: BorderRadius.circular(15), boxShadow: [if (isSelected && !isDark) BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
        child: Center(child: Text(title, style: TextStyle(fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600, color: isSelected ? (isDark ? Colors.white : Colors.black) : Colors.grey, fontSize: 14))),
      ),
    );
  }

  Widget _summaryRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600, fontSize: 14)),
        Text(value, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16)),
      ],
    );
  }
}
