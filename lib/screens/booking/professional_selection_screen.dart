import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/home_provider.dart';
import '../../providers/theme_provider.dart';
import 'professional_profile_screen.dart';

class ProfessionalSelectionScreen extends StatefulWidget {
  final String? eventType;
  final String? initialCategory;
  const ProfessionalSelectionScreen({super.key, this.eventType, this.initialCategory});

  @override
  State<ProfessionalSelectionScreen> createState() => _ProfessionalSelectionScreenState();
}

class _ProfessionalSelectionScreenState extends State<ProfessionalSelectionScreen> {
  String _selectedCategory = 'All';
  final ScrollController _categoryScrollController = ScrollController();

  final Map<String, List<String>> _eventCategoryPrefs = {
    'Wedding': ['Photographers', 'Videographers', 'Makeup Artists', 'Musicians'],
    'Pre-Wedding': ['Photographers', 'Videographers', 'Makeup Artists'],
    'Birthday': ['Photographers', 'Videographers', 'Dancers', 'Musicians'],
    'Anniversary': ['Photographers', 'Musicians'],
  };

  @override
  void initState() {
    super.initState();
    
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    } else if (widget.eventType != null && _eventCategoryPrefs.containsKey(widget.eventType)) {
      // Default to the first preferred category for the event
      _selectedCategory = _eventCategoryPrefs[widget.eventType!]![0];
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingProvider>(context, listen: false).fetchVendors();
      Provider.of<HomeProvider>(context, listen: false).fetchHomeData();
      
      // Initial scroll if a category is pre-selected
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          final homeProvider = Provider.of<HomeProvider>(context, listen: false);
          _scrollToSelectedCategory(_getProcessedCategories(homeProvider));
        }
      });
    });
  }

  @override
  void dispose() {
    _categoryScrollController.dispose();
    super.dispose();
  }

  List<String> _getProcessedCategories(HomeProvider homeProvider) {
    List<String> categories = homeProvider.categories.map((c) => c['title'].toString()).toList();
    if (widget.eventType != null && _eventCategoryPrefs.containsKey(widget.eventType)) {
      final prefs = _eventCategoryPrefs[widget.eventType!]!;
      List<String> preferred = [];
      List<String> others = [];
      for (var cat in categories) {
        if (prefs.contains(cat)) preferred.add(cat);
        else others.add(cat);
      }
      preferred.sort((a, b) => prefs.indexOf(a).compareTo(prefs.indexOf(b)));
      return [...preferred, ...others, 'All'];
    }
    return ['All', ...categories];
  }

  void _scrollToSelectedCategory(List<String> categories) {
    if (!_categoryScrollController.hasClients) return;
    
    final index = categories.indexOf(_selectedCategory);
    if (index != -1) {
      // Align to the left (with the list's 20px padding)
      // Each pill approx width is 100
      double offset = index * 105.0; 
      
      _categoryScrollController.animateTo(
        offset.clamp(0, _categoryScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    // Filter vendors by selected category
    final vendors = _selectedCategory == 'All' 
        ? bookingProvider.vendors 
        : bookingProvider.vendors.where((v) => v['category'] == _selectedCategory).toList();

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Pick a Professional',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w900,
            fontSize: 22,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : Colors.black, size: 20),
        ),
      ),
      body: Column(
        children: [
          _buildCategoryPills(homeProvider, isDark),
          Expanded(
            child: bookingProvider.isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFE91E63)))
                : vendors.isEmpty
                    ? _buildEmptyState(isDark)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        itemCount: vendors.length,
                        itemBuilder: (context, index) {
                          final pro = vendors[index];
                          return FadeInRight(
                            delay: Duration(milliseconds: 100 * index),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    )
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ProfessionalProfileScreen(
                                          vendorId: pro['_id'],
                                          name: pro['name'] ?? 'N/A',
                                          role: pro['category'] ?? 'Professional',
                                          image: pro['profilePic'] ?? 'https://i.pravatar.cc/150?u=${pro['name']}',
                                        ),
                                      ),
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15),
                                      child: Row(
                                        children: [
                                          Hero(
                                            tag: pro['name'] ?? pro['_id'],
                                            child: Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                image: DecorationImage(
                                                  image: NetworkImage(pro['profilePic'] ?? 'https://i.pravatar.cc/150?u=${pro['name']}'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 18),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  pro['name'] ?? 'Artist',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 18,
                                                    color: isDark ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  pro['category'] ?? 'Professional',
                                                  style: TextStyle(
                                                    color: Colors.grey[500],
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      '${pro['rating'] ?? '4.9'}',
                                                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                      decoration: BoxDecoration(
                                                        color: const Color(0xFFE91E63).withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(10),
                                                      ),
                                                      child: Text(
                                                        '\u20B9${pro['hourlyRate'] ?? '1,499'}/hr',
                                                        style: const TextStyle(
                                                          color: Color(0xFFE91E63),
                                                          fontWeight: FontWeight.w900,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            color: Colors.grey[400],
                                            size: 24,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryPills(HomeProvider homeProvider, bool isDark) {
    final categories = _getProcessedCategories(homeProvider);
    
    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        controller: _categoryScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat;
          
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = cat);
              _scrollToSelectedCategory(categories);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE91E63) : (isDark ? const Color(0xFF1A1A1A) : Colors.white),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected ? const Color(0xFFE91E63) : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: const Color(0xFFE91E63).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ] : [],
              ),
              child: Center(
                child: Text(
                  cat,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black54),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_search_rounded, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Text(
            'No professionals found',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Try selecting a different category',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
