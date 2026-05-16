import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';
import 'cart_screen.dart';
import 'package:intl/intl.dart';

class ComboSelectionScreen extends StatefulWidget {
  final DateTime date;
  final String startTime;
  final int duration;

  const ComboSelectionScreen({
    super.key,
    required this.date,
    required this.startTime,
    required this.duration,
  });

  @override
  State<ComboSelectionScreen> createState() => _ComboSelectionScreenState();
}

class _ComboSelectionScreenState extends State<ComboSelectionScreen> {
  int? selectedPhotoIndex;
  int? selectedVideoIndex;
  bool _isLoading = true;

  List<dynamic> photographers = [];
  List<dynamic> videographers = [];

  @override
  void initState() {
    super.initState();
    _fetchAvailableTalents();
  }

  Future<void> _fetchAvailableTalents() async {
    final dateStr = DateFormat('yyyy-MM-dd').format(widget.date);
    final talents = await ApiService.getAvailableVendors(dateStr, widget.startTime, widget.duration);
    
    if (mounted) {
      setState(() {
        photographers = talents.where((t) => t['category'] == 'Photographer').toList();
        videographers = talents.where((t) => t['category'] == 'Videographer').toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Bundle & Save', style: GoogleFonts.plusJakartaSans(color: isDark ? Colors.white : Colors.black, fontWeight: FontWeight.w900, fontSize: 22)),
        centerTitle: true,
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : Colors.black, size: 20)),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
        : Column(
            children: [
              _buildPromoBanner(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildSectionTitle('Pick your Photographer'),
                    const SizedBox(height: 20),
                    if (photographers.isEmpty) 
                      _buildEmptyState('No photographers available for this slot.')
                    else
                      ...List.generate(photographers.length, (i) => _buildSelectionCard(i, photographers[i], true, isDark)),
                    const SizedBox(height: 40),
                    _buildSectionTitle('Pick your Videographer'),
                    const SizedBox(height: 20),
                    if (videographers.isEmpty)
                      _buildEmptyState('No videographers available for this slot.')
                    else
                      ...List.generate(videographers.length, (i) => _buildSelectionCard(i, videographers[i], false, isDark)),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
      bottomSheet: _isLoading ? null : _buildBottomAction(isDark),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(message, style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildPromoBanner() {
    return FadeInDown(
      child: Container(
        width: double.infinity, margin: const EdgeInsets.fromLTRB(25, 10, 25, 20),
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF5252)]),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [BoxShadow(color: const Color(0xFFE91E63).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
              child: const Icon(Icons.flash_on_rounded, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Power Bundle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                  Text('Book both together and get 20% flat discount.', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5));
  }

  Widget _buildSelectionCard(int index, dynamic pro, bool isPhoto, bool isDark) {
    bool isSelected = isPhoto ? selectedPhotoIndex == index : selectedVideoIndex == index;
    return FadeInUp(
      delay: Duration(milliseconds: 100 * index),
      child: GestureDetector(
        onTap: () => setState(() => isPhoto ? selectedPhotoIndex = index : selectedVideoIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.only(bottom: 15),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE91E63).withOpacity(0.05) : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: isSelected ? const Color(0xFFE91E63) : Colors.black.withOpacity(0.03), width: 2),
            boxShadow: isSelected ? [] : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: Row(
            children: [
              Container(
                height: 70, width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18), 
                  image: DecorationImage(
                    image: NetworkImage(pro['profilePic'] ?? 'https://via.placeholder.com/150'), 
                    fit: BoxFit.cover
                  )
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pro['name'] ?? 'Talent', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('\u20B9${pro['hourlyRate'] ?? '1,499'}/hr', style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              if (isSelected) 
                const Icon(Icons.check_circle_rounded, color: Color(0xFFE91E63), size: 28)
              else 
                Container(height: 24, width: 24, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[300]!, width: 2))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction(bool isDark) {
    bool canConfirm = selectedPhotoIndex != null && selectedVideoIndex != null;
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: FadeInUp(
        child: GestureDetector(
          onTap: canConfirm ? () {
            final cart = Provider.of<CartProvider>(context, listen: false);
            final p = photographers[selectedPhotoIndex!];
            final v = videographers[selectedVideoIndex!];
            
            cart.addToCart(CartItem(
              id: p['_id'], 
              name: p['name'], 
              role: 'Photographer', 
              price: '\u20B9${p['hourlyRate']}/hr', 
              image: p['profilePic'] ?? 'https://via.placeholder.com/150',
              date: widget.date,
              time: widget.startTime,
              hours: widget.duration,
            ));
            cart.addToCart(CartItem(
              id: v['_id'], 
              name: v['name'], 
              role: 'Videographer', 
              price: '\u20B9${v['hourlyRate']}/hr', 
              image: v['profilePic'] ?? 'https://via.placeholder.com/150',
              date: widget.date,
              time: widget.startTime,
              hours: widget.duration,
            ));
            
            Navigator.popUntil(context, (route) => route.isFirst);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
          } : null,
          child: Container(
            width: double.infinity, height: 70,
            decoration: BoxDecoration(
              color: canConfirm ? const Color(0xFF1A1A1A) : Colors.grey[300],
              borderRadius: BorderRadius.circular(25),
              boxShadow: canConfirm ? [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 10))] : [],
            ),
            child: Center(
              child: Text(
                canConfirm ? 'Complete Bundle Selection' : 'Select Both to Continue', 
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)
              ),
            ),
          ),
        ),
      ),
    );
  }
}
