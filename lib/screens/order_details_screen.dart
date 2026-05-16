import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  final List<dynamic>? allBookings;
  const OrderDetailsScreen({super.key, required this.orderId, this.allBookings});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  Map<String, dynamic>? _booking;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    final data = await ApiService.getBookingDetails(widget.orderId);
    if (mounted) {
      setState(() {
        _booking = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFBFBFB),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _booking == null 
          ? const Center(child: Text('Order not found'))
          : CustomScrollView(
              slivers: [
                _buildSliverAppBar(context, isDark),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStatusHeader(isDark),
                        const SizedBox(height: 40),
                        _buildSectionTitle('Project Milestones'),
                        _buildMilestones(isDark),
                        const SizedBox(height: 40),
                        _buildSectionTitle('Version History (Revisions)'),
                        _buildVersionList(isDark),
                        const SizedBox(height: 40),
                        _buildSectionTitle('Payment Summary'),
                        _buildPaymentCard(isDark),
                        const SizedBox(height: 40),
                        _buildSectionTitle(widget.allBookings != null ? 'Professionals in Combo' : 'Vendor Details'),
                        if (widget.allBookings != null)
                          ...widget.allBookings!.map((b) => Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: _buildVendorCard(isDark, bookingOverride: b),
                          ))
                        else
                          _buildVendorCard(isDark),
                        const SizedBox(height: 40),
                        _buildSectionTitle('Feedback & Contact'),
                        _buildFeedbackContact(isDark),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // ... (keeping sliver, status header, etc)

  Widget _buildVersionList(bool isDark) {
    final List<dynamic> revisions = _booking!['revisions'] ?? [];
    if (revisions.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: isDark ? Colors.white12 : Colors.grey[100], borderRadius: BorderRadius.circular(20)),
        child: const Center(child: Text('No revisions available yet', style: TextStyle(color: Colors.grey))),
      );
    }
    return Column(
      children: revisions.map((rev) => _buildVersionItem(rev['version'] ?? 'V1.0', rev['description'] ?? 'Work updated', isDark)).toList(),
    );
  }

  Widget _buildVersionItem(String title, String desc, bool isDark) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: const Color(0xFFE91E63).withOpacity(0.1), shape: BoxShape.circle),
        child: const Icon(Icons.history_rounded, color: Color(0xFFE91E63), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(desc, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
      trailing: IconButton(icon: const Icon(Icons.download_rounded), onPressed: () {}),
    );
  }

  Widget _buildFeedbackContact(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildActionBtn(
            Icons.star_outline_rounded, 
            'Review', 
            Colors.orange,
            () => _showReviewDialog(context),
          )
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _buildActionBtn(
            Icons.chat_bubble_outline_rounded, 
            'Support', 
            const Color(0xFFE91E63),
            () => ApiService.contactSupport(widget.orderId),
          )
        ),
      ],
    );
  }

  void _showReviewDialog(BuildContext context) {
    double rating = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          title: const Text('Rate your experience', style: TextStyle(fontWeight: FontWeight.w900)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) => IconButton(
                  icon: Icon(index < rating ? Icons.star_rounded : Icons.star_outline_rounded, color: Colors.orange, size: 32),
                  onPressed: () => setState(() => rating = index + 1.0),
                )),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Share your feedback...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE91E63), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () async {
                final success = await ApiService.submitReview(widget.orderId, rating, commentController.text);
                if (success) {
                  Navigator.pop(ctx);
                  _fetchDetails();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Review submitted!')));
                }
              },
              child: const Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBtn(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05), 
          borderRadius: BorderRadius.circular(25), 
          border: Border.all(color: color.withOpacity(0.2))
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28), 
            const SizedBox(height: 8), 
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 15))
          ]
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool isDark) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFBFBFB),
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(color: isDark ? Colors.white12 : Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          'Order Details',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w900, 
            fontSize: 20,
            color: isDark ? Colors.white : Colors.black
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
    );
  }

  Widget _buildStatusHeader(bool isDark) {
    return FadeInDown(
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF5252)]),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [BoxShadow(color: const Color(0xFFE91E63).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: SS-${widget.orderId.substring(widget.orderId.length - 8).toUpperCase()}', 
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 0.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(height: 8, width: 8, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Text(
                        'Status: ${_booking!['status']?.toString().toUpperCase() ?? 'CONFIRMED'}', 
                        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 12, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestones(bool isDark) {
    final List<String> steps = ['Booking Accepted', 'Professional Assigned', 'Shoot Scheduled', 'Editing Phase', 'Final Delivery'];
    return Column(
      children: List.generate(steps.length, (index) {
        bool isDone = index < 1; // Real logic would check actual status
        bool isCurrent = index == 0;
        return FadeInLeft(
          delay: Duration(milliseconds: 100 * index),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    height: 24, width: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, 
                      color: isDone ? const Color(0xFFE91E63) : (isDark ? Colors.white12 : Colors.grey[200]),
                      border: isCurrent ? Border.all(color: const Color(0xFFE91E63), width: 2) : null
                    ),
                    child: isDone ? const Icon(Icons.check, size: 14, color: Colors.white) : (isCurrent ? Center(child: Container(height: 8, width: 8, decoration: const BoxDecoration(color: Color(0xFFE91E63), shape: BoxShape.circle))) : null),
                  ),
                  if (index < steps.length - 1) Container(width: 2, height: 40, color: isDone ? const Color(0xFFE91E63) : (isDark ? Colors.white12 : Colors.grey[200])),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(steps[index], style: GoogleFonts.plusJakartaSans(color: isDone || isCurrent ? (isDark ? Colors.white : Colors.black) : Colors.grey[400], fontWeight: isDone || isCurrent ? FontWeight.w800 : FontWeight.w600, fontSize: 16)),
                      if (isCurrent) Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('Completed on ${DateFormat('MMM dd, yyyy').format(DateTime.now())}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildPaymentCard(bool isDark) {
    double amount = _booking!['totalAmount']?.toDouble() ?? 0.0;
    if (widget.allBookings != null) {
      amount = widget.allBookings!.fold(0.0, (sum, item) => sum + (item['totalAmount']?.toDouble() ?? 0.0));
    }
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white, 
        borderRadius: BorderRadius.circular(35), 
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
        boxShadow: [if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))]
      ),
      child: Column(
        children: [
          _buildInfoRow('Service Charge', '\u20B9${amount.toInt()}', isDark),
          const SizedBox(height: 12),
          _buildInfoRow('Taxes & Fees', '\u20B90', isDark),
          const Divider(height: 40, thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Paid', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 18)),
              Text('\u20B9${amount.toInt()}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 22, color: const Color(0xFF4CAF50))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVendorCard(bool isDark, {dynamic bookingOverride}) {
    final bookingData = bookingOverride ?? _booking;
    final vendor = bookingData!['vendor'] ?? {};
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white, 
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            height: 60, width: 60,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), image: DecorationImage(image: NetworkImage(vendor['profilePic'] ?? 'https://i.pravatar.cc/150'), fit: BoxFit.cover)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vendor['name'] ?? 'Professional', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 4),
                Text(vendor['category'] ?? 'Talent', style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFE91E63).withOpacity(0.1), shape: BoxShape.circle),
            child: const Icon(Icons.chat_bubble_rounded, color: Color(0xFFE91E63), size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, 
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w600, fontSize: 14)), 
        Text(value, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16))
      ]
    );
  }
}
