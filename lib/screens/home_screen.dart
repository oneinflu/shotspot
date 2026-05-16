import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../widgets/section_header.dart';
import '../widgets/shot_card.dart';
import '../widgets/combo_card.dart';
import '../providers/cart_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/home_provider.dart';
import '../providers/user_provider.dart';

import 'booking/booking_discover_screen.dart';
import 'booking/professional_selection_screen.dart';
import 'combo_config_screen.dart';
import 'combo_selection_screen.dart';
import 'cart_screen.dart';
import 'shots_reel_screen.dart';
import 'all_combos_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController(viewportFraction: 0.85);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeProvider>(context, listen: false).fetchHomeData();
    });
  }

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  Widget _buildAvatarPlaceholder(String name, {double size = 16}) {
    String initials = '';
    if (name.isNotEmpty) {
      initials = name.trim().split(' ').map((e) => e[0]).take(2).join().toUpperCase();
    }
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFE91E63).withOpacity(0.2),
            const Color(0xFFE91E63).withOpacity(0.05),
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFFE91E63),
            fontWeight: FontWeight.w800,
            fontSize: size,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final cart = Provider.of<CartProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFFBFBFB),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context, cart, isDark),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildSearchBar(isDark),
                const SizedBox(height: 20),
                _buildBannerSlider(homeProvider),
                const SizedBox(height: 20),
                SectionHeader(
                  title: 'Top Viewed Shots', 
                  actionLabel: 'Explore All',
                  onAction: () => Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder: (_) => ShotsReelScreen(shots: homeProvider.shots)
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _buildShotsList(homeProvider),
                const SizedBox(height: 20),
                _buildCategoriesGrid(homeProvider, isDark),
                const SizedBox(height: 20),
                _buildExclusiveCombos(context, isDark, homeProvider),
                const SizedBox(height: 150),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, CartProvider cart, bool isDark) {
    final user = Provider.of<UserProvider>(context);
    final userName = user.name ?? 'Guest';
    final profilePic = user.profilePic;

    return SliverAppBar(
      floating: true,
      backgroundColor: isDark ? const Color(0xFF0F0F0F) : const Color(0xFFFBFBFB),
      elevation: 0,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Center(
          child: Container(
            height: 45, width: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFE91E63).withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black.withOpacity(0.05)),
            ),
            child: profilePic != null && profilePic.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.network(profilePic, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(userName)),
                  )
                : _buildAvatarPlaceholder(userName),
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_getGreeting(), style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600)),
          Text(userName, style: GoogleFonts.plusJakartaSans(color: isDark ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.w900)),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen())),
          child: Container(
            margin: const EdgeInsets.only(right: 20),
            height: 45, width: 45,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.white, 
              shape: BoxShape.circle, 
              border: Border.all(color: Colors.black.withOpacity(0.05))
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, color: isDark ? Colors.white : Colors.black, size: 20),
                if (cart.items.isNotEmpty)
                  Positioned(
                    top: 10, right: 10,
                    child: Container(
                      height: 10, width: 10,
                      decoration: const BoxDecoration(color: Color(0xFFE91E63), shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid(HomeProvider provider, bool isDark) {
    final categories = provider.categories;
    if (categories.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Find Talent',
          actionLabel: 'Browse All',
          onAction: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ProfessionalSelectionScreen(),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 25,
              crossAxisSpacing: 20,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final cat = categories[index];
              return FadeInUp(
                delay: Duration(milliseconds: 50 * index),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfessionalSelectionScreen(
                        initialCategory: cat['title'],
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.05),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: Image.network(
                            cat['image'],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Icon(Icons.stars, color: Colors.grey[400]),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        cat['title'],
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white70 : Colors.black87,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: FadeInDown(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 60,
          decoration: BoxDecoration(
            color: isDark ? Colors.white10 : Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: Color(0xFFE91E63), size: 24),
              const SizedBox(width: 15),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search skills, artists...',
                    hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400], fontSize: 14, fontWeight: FontWeight.w600),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 40, width: 40,
                decoration: BoxDecoration(color: const Color(0xFF1A1A1A), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.tune_rounded, color: Colors.white, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSlider(HomeProvider provider) {
    if (provider.isLoading && provider.banners.isEmpty) {
      return const SizedBox(height: 220, child: Center(child: CircularProgressIndicator()));
    }
    final banners = provider.banners;
    if (banners.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 220,
      child: PageView.builder(
        itemCount: banners.length,
        controller: _bannerController,
        itemBuilder: (context, index) {
          final banner = banners[index];
          return AnimatedBuilder(
            animation: _bannerController,
            builder: (context, child) {
              double value = 1.0;
              if (_bannerController.position.hasContentDimensions) {
                value = _bannerController.page! - index;
                value = (1 - (value.abs() * 0.1)).clamp(0.0, 1.0);
              }
              return Center(
                child: SizedBox(
                  height: Curves.easeOut.transform(value) * 220,
                  width: Curves.easeOut.transform(value) * 400,
                  child: child,
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(35),
                image: DecorationImage(
                  image: NetworkImage(banner['image']),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) => debugPrint('Banner image load error: $exception'),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  gradient: LinearGradient(begin: Alignment.bottomRight, colors: [Colors.black.withOpacity(0.8), Colors.transparent]),
                ),
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: const Color(0xFFE91E63), borderRadius: BorderRadius.circular(8)),
                      child: Text(banner['type'].toString().toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                    ),
                    const SizedBox(height: 10),
                    Text(banner['title'], style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.1)),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShotsList(HomeProvider provider) {
    final shots = provider.shots;
    if (shots.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 320,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: shots.length,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemBuilder: (context, index) {
          final shot = shots[index];
          return FadeInRight(
            delay: Duration(milliseconds: 100 * index),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: ShotCard(
                index: index, 
                imagePath: shot['thumbnail'], 
                author: '@${shot['artist'].toString().replaceAll(' ', '_').toLowerCase()}', 
                title: shot['title'],
                onTap: () => Navigator.push(
                  context, 
                  MaterialPageRoute(
                    builder: (_) => ShotsReelScreen(shots: provider.shots, initialIndex: index)
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildExclusiveCombos(BuildContext context, bool isDark, HomeProvider provider) {
    final combos = provider.combos;
    if (combos.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Exclusive Combos', 
          actionLabel: 'View All',
          onAction: () => Navigator.push(
            context, 
            MaterialPageRoute(builder: (_) => const AllCombosScreen())
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 240,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: combos.length,
            itemBuilder: (context, index) {
              final combo = combos[index];
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ComboConfigScreen())),
                child: Container(
                  width: 300,
                  margin: const EdgeInsets.only(right: 15),
                  child: ComboCard(
                    title: combo['name'], 
                    price: '\u20B9${combo['price']}', 
                    imagePath: combo['image'], 
                    accentColor: index % 2 == 0 ? const Color(0xFFE91E63) : const Color(0xFF2196F3)
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
