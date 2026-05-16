import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/cart_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/theme_provider.dart';
import '../cart_screen.dart';

class ProfessionalProfileScreen extends StatefulWidget {
  final String vendorId;
  final String name;
  final String role;
  final String image;

  const ProfessionalProfileScreen({
    super.key, 
    required this.vendorId,
    required this.name, 
    required this.role, 
    required this.image
  });

  @override
  State<ProfessionalProfileScreen> createState() => _ProfessionalProfileScreenState();
}

class _ProfessionalProfileScreenState extends State<ProfessionalProfileScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showTitle) {
        setState(() => _showTitle = true);
      } else if (_scrollController.offset <= 300 && _showTitle) {
        setState(() => _showTitle = false);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).fetchVendorDetails(widget.vendorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final details = bookingProvider.selectedVendorDetails;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFFBFBFB),
      body: bookingProvider.isLoading && details == null
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
          : Stack(
              children: [
                CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    _buildSliverAppBar(context, details),
                    SliverToBoxAdapter(child: _buildMainContent(context, isDark, details)),
                  ],
                ),
                _buildFloatingAction(context, isDark, details),
              ],
            ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Map<String, dynamic>? details) {
    return SliverAppBar(
      expandedHeight: 450,
      pinned: true,
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: const Icon(Icons.favorite_outline_rounded, color: Colors.black, size: 20),
          ),
        ),
      ],
      title: _showTitle ? Text(widget.name, style: GoogleFonts.plusJakartaSans(color: Colors.black, fontWeight: FontWeight.w900)) : null,
      flexibleSpace: FlexibleSpaceBar(
        background: Hero(
          tag: widget.name,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                widget.image, 
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.person, size: 100, color: Colors.grey),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.3), Colors.transparent, Colors.black.withOpacity(0.5)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, bool isDark, Map<String, dynamic>? details) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFFBFBFB),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1.5)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                      const SizedBox(width: 4),
                      Text('${details?['rating'] ?? '4.9'}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(width: 8),
                      Text('(${details?['numReviews'] ?? '120'} Reviews)', style: TextStyle(color: Colors.grey[500], fontSize: 14)),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: const Color(0xFFE91E63).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.verified_rounded, color: Color(0xFFE91E63), size: 24),
              ),
            ],
          ),
          const SizedBox(height: 35),
          _buildGlassStats(isDark, details),
          const SizedBox(height: 40),
          _buildSectionTitle('About Me'),
          const SizedBox(height: 12),
          Text(
            details?['about'] ?? 'Award-winning ${widget.role} with over 5 years of excellence. My style focuses on natural light, genuine emotions, and cinematic storytelling that preserves your most precious memories forever.',
            style: TextStyle(color: Colors.grey[600], height: 1.7, fontSize: 15),
          ),
          const SizedBox(height: 40),
          _buildPortfolio(isDark, details),
          const SizedBox(height: 40),
          _buildPackages(isDark, details),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildGlassStats(bool isDark, Map<String, dynamic>? details) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem(details?['projects'] ?? '1.2k', 'Projects'),
          _divider(),
          _statItem(details?['experience'] ?? '5 yrs', 'Experience'),
          _divider(),
          _statItem(details?['positiveReviewPercent'] ?? '98%', 'Positive'),
        ],
      ),
    );
  }

  Widget _divider() => Container(height: 30, width: 1, color: Colors.grey.withOpacity(0.2));

  Widget _statItem(String val, String label) {
    return Column(
      children: [
        Text(val, style: GoogleFonts.plusJakartaSans(fontSize: 20, fontWeight: FontWeight.w900)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 22, fontWeight: FontWeight.w900));
  }

  Widget _buildPortfolio(bool isDark, Map<String, dynamic>? details) {
    final List<dynamic> gallery = details?['gallery'] ?? [];
    if (gallery.isEmpty) return const SizedBox();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSectionTitle('Gallery'),
            Text('View All', style: TextStyle(color: const Color(0xFFE91E63), fontWeight: FontWeight.w800, fontSize: 13)),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: gallery.length,
            itemBuilder: (context, index) {
              return FadeInRight(
                delay: Duration(milliseconds: index * 100),
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    image: DecorationImage(
                      image: NetworkImage(gallery[index]), 
                      fit: BoxFit.cover
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPackages(bool isDark, Map<String, dynamic>? details) {
    final List<dynamic> packages = details?['packages'] ?? [];
    if (packages.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Featured Packages'),
        const SizedBox(height: 20),
        ...packages.map((pkg) => _packageCard(
          pkg['title'] ?? 'Session', 
          pkg['features']?.join(', ') ?? 'Professional coverage', 
          '\u20B9${pkg['price'] ?? '4,999'}', 
          isDark
        )).toList(),
      ],
    );
  }

  Widget _packageCard(String title, String sub, String price, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.03)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                const SizedBox(height: 4),
                Text(sub, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          Text(price, style: const TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.w900, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildFloatingAction(BuildContext context, bool isDark, Map<String, dynamic>? details) {
    return Positioned(
      bottom: 40,
      left: 25,
      right: 25,
      child: FadeInUp(
        child: GestureDetector(
          onTap: () => _showBookingSheet(context, isDark, details),
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Center(
              child: Text('Book This Professional', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18)),
            ),
          ),
        ),
      ),
    );
  }

  void _showBookingSheet(BuildContext context, bool isDark, Map<String, dynamic>? details) {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    
    // Fetch busy dates as soon as the sheet opens
    bookingProvider.fetchBusyDates(widget.vendorId);

    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    String selectedTime = "10:00 AM";
    int selectedHours = 2;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final busyDates = Provider.of<BookingProvider>(context).busyDates;

            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
              ),
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                  const SizedBox(height: 30),
                  Text('Set Booking Details', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 35),
                  
                  Text('Select Preferred Date', style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1)),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 14,
                      itemBuilder: (context, index) {
                        final date = DateTime.now().add(Duration(days: index + 1));
                        final dateStr = DateFormat('yyyy-MM-dd').format(date);
                        final isSelected = selectedDate.day == date.day && selectedDate.month == date.month;
                        final isBlocked = busyDates.contains(dateStr);
                        
                        return GestureDetector(
                          onTap: isBlocked ? null : () => setSheetState(() => selectedDate = date),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 70,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFE91E63) : (isBlocked ? (isDark ? Colors.white10 : Colors.grey[100]) : Colors.transparent),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: isSelected ? const Color(0xFFE91E63) : (isBlocked ? Colors.transparent : (isDark ? Colors.white12 : Colors.grey[200]!))),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1], style: TextStyle(color: isSelected ? Colors.white70 : Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text('${date.day}', style: TextStyle(color: isSelected ? Colors.white : (isBlocked ? Colors.grey[400] : (isDark ? Colors.white : Colors.black)), fontWeight: FontWeight.w900, fontSize: 20)),
                                if (isBlocked) const Icon(Icons.lock_outline_rounded, size: 12, color: Colors.grey),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: _bookingControl('Starting Time', selectedTime, Icons.access_time_rounded, () async {
                          final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                          if (time != null) setSheetState(() => selectedTime = time.format(context));
                        }, isDark),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _bookingControl('Duration', '$selectedHours Hours', Icons.timer_outlined, null, isDark, counter: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _counterBtn(Icons.remove, () => setSheetState(() => selectedHours = selectedHours > 1 ? selectedHours - 1 : 1), isDark),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('$selectedHours', style: const TextStyle(fontWeight: FontWeight.w900))),
                            _counterBtn(Icons.add, () => setSheetState(() => selectedHours = selectedHours < 12 ? selectedHours + 1 : 12), isDark),
                          ],
                        )),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      final cart = Provider.of<CartProvider>(context, listen: false);
                      cart.addToCart(CartItem(
                        id: widget.vendorId,
                        name: widget.name,
                        role: widget.role,
                        price: '\u20B9${details?['hourlyRate'] ?? '1,499'}/hr',
                        image: widget.image,
                        date: selectedDate,
                        time: selectedTime,
                        hours: selectedHours,
                      ));
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                    },
                    child: Container(
                      width: double.infinity, height: 70,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF5252)]),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [BoxShadow(color: const Color(0xFFE91E63).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 10))],
                      ),
                      child: const Center(child: Text('Confirm Booking', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18))),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _bookingControl(String label, String val, IconData icon, VoidCallback? onTap, bool isDark, {Widget? counter}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 0.5)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100], 
              borderRadius: BorderRadius.circular(20)
            ),
            child: counter ?? Row(
              children: [
                Icon(icon, size: 18, color: const Color(0xFFE91E63)),
                const SizedBox(width: 10),
                Text(val, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _counterBtn(IconData icon, VoidCallback onTap, bool isDark) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark ? Colors.black26 : Colors.white, 
          borderRadius: BorderRadius.circular(8)
        ),
        child: Icon(icon, size: 16, color: isDark ? Colors.white : Colors.black),
      ),
    );
  }
}
