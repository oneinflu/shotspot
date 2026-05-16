import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/theme_provider.dart';
import '../providers/booking_provider.dart';
import '../providers/user_provider.dart';
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = Provider.of<UserProvider>(context, listen: false);
      if (user.id != null) {
        Provider.of<BookingProvider>(context, listen: false).fetchUserBookings(user.id!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final bookingProvider = Provider.of<BookingProvider>(context);
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFBFBFB),
      body: RefreshIndicator(
        onRefresh: () async {
          final user = Provider.of<UserProvider>(context, listen: false);
          if (user.id != null) {
            await bookingProvider.fetchUserBookings(user.id!);
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                'My Orders',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 24),
              ),
            ),
            if (bookingProvider.isLoading)
              const SliverFillRemaining(child: Center(child: CircularProgressIndicator()))
            else if (bookingProvider.userBookings.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
                      const SizedBox(height: 20),
                      Text('No orders yet', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.grey)),
                    ],
                  ),
                ),
              )
            else ...() {
              // Group bookings by paymentId
              final Map<String, List<dynamic>> groupedBookings = {};
              for (var b in bookingProvider.userBookings) {
                final pid = b['paymentId'] ?? b['_id']; // Fallback to id if no paymentId
                if (!groupedBookings.containsKey(pid)) {
                  groupedBookings[pid] = [];
                }
                groupedBookings[pid]!.add(b);
              }
              final groupedList = groupedBookings.values.toList();

              return [
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final bookings = groupedList[index];
                        return _buildOrderSummaryCard(context, bookings, index, isDark);
                      },
                      childCount: groupedList.length,
                    ),
                  ),
                ),
              ];
            }(),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(BuildContext context, List<dynamic> bookings, int index, bool isDark) {
    final isCombo = bookings.length > 1;
    final firstBooking = bookings.first;
    final vendor = firstBooking['vendor'] ?? {};
    final status = firstBooking['status'] ?? 'Confirmed';
    final dateStr = firstBooking['date'] != null 
        ? DateFormat('MMM dd').format(DateTime.parse(firstBooking['date']))
        : 'Unknown Date';

    // Calculate total for the group
    final double totalAmount = bookings.fold(0.0, (sum, item) => sum + (item['totalAmount']?.toDouble() ?? 0.0));

    return FadeInUp(
      delay: Duration(milliseconds: 100 * index),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(
              orderId: firstBooking['_id'],
              allBookings: isCombo ? bookings : null,
            )
          )
        ),
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05)),
            boxShadow: [
              if (!isDark) BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 8))
            ]
          ),
          child: Column(
            children: [
              Row(
                children: [
                  if (isCombo)
                    Container(
                      height: 60, width: 60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE91E63).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15), 
                      ),
                      child: const Icon(Icons.auto_awesome_motion_rounded, color: Color(0xFFE91E63), size: 30),
                    )
                  else
                    Container(
                      height: 60, width: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15), 
                        image: DecorationImage(
                          image: NetworkImage(vendor['profilePic'] ?? 'https://i.pravatar.cc/150'), 
                          fit: BoxFit.cover
                        )
                      ),
                    ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCombo ? 'Exclusive Combo' : (vendor['name'] ?? 'Booking'), 
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16)
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isCombo 
                            ? '${bookings.length} Professionals • $dateStr'
                            : '${vendor['category'] ?? 'Professional'} • $dateStr', 
                          style: TextStyle(color: Colors.grey[500], fontSize: 13)
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: (status == 'confirmed' ? Colors.green : Colors.orange).withOpacity(0.1), 
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(
                      status.toString().toUpperCase(), 
                      style: TextStyle(
                        color: status == 'confirmed' ? Colors.green : Colors.orange, 
                        fontSize: 9, 
                        fontWeight: FontWeight.w900
                      )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      Text('Amount Paid', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w600)), 
                      const SizedBox(height: 2),
                      Text('\u20B9${totalAmount.toStringAsFixed(0)}', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w900, fontSize: 16))
                    ]
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.grey.withOpacity(0.05), shape: BoxShape.circle),
                    child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey[400]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
