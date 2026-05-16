import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/booking/booking_discover_screen.dart';
import 'screens/booking/event_type_screen.dart';
import 'widgets/custom_bottom_nav.dart';
import 'providers/theme_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/home_provider.dart';
import 'providers/user_provider.dart';
import 'providers/booking_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const ShotSpotApp(),
    ),
  );
}

class ShotSpotApp extends StatelessWidget {
  const ShotSpotApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDark = themeProvider.isDarkMode;

    return MaterialApp(
      title: 'ShotSpot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: isDark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFBFBFB),
        primaryColor: const Color(0xFFE91E63),
        colorScheme: ColorScheme.fromSeed(
          brightness: isDark ? Brightness.dark : Brightness.light,
          seedColor: const Color(0xFFE91E63),
          primary: const Color(0xFFE91E63),
          surface: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme().apply(
          bodyColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
          displayColor: isDark ? Colors.white : const Color(0xFF1A1A1A),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class MainWrapper extends StatefulWidget {
  final int initialIndex;
  const MainWrapper({super.key, this.initialIndex = 0});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    const HomeScreen(),
    const BookingDiscoverScreen(),
    const CartScreen(),
    const OrdersScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    
    // Hide default AppBar for Booking, Cart, Orders, and Profile screens
    bool hideAppBar = _currentIndex == 1 || _currentIndex == 2 || _currentIndex == 3 || _currentIndex == 4;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFBFBFB),
      appBar: hideAppBar ? null : AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: FadeInDown(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                  ),
                  children: [
                    TextSpan(text: 'Shot', style: TextStyle(color: isDark ? Colors.white : const Color(0xFF1A1A1A))),
                    const TextSpan(text: 'Spot', style: TextStyle(color: Color(0xFFE91E63))),
                  ],
                ),
              ),
              _buildBookNowButton(),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _screens),
          CustomBottomNav(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
          ),
        ],
      ),
    );
  }

  Widget _buildBookNowButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF5252)]),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE91E63).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const EventTypeScreen()));
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Text(
              'Book Now',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
