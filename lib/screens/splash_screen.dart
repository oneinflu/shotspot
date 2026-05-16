import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'auth/login_screen.dart';
import '../main.dart';
import '../services/api_service.dart';
import '../providers/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _zoomController;
  late Animation<double> _zoomAnimation;

  @override
  void initState() {
    super.initState();
    _zoomController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _zoomAnimation = CurvedAnimation(parent: _zoomController, curve: Curves.elasticOut);
    _zoomController.forward();

    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    debugPrint('Splash: Checking login status...');
    try {
      // Load persisted data
      await ApiService.loadToken();
      debugPrint('Splash: Token loaded');
      
      if (mounted) {
        await Provider.of<UserProvider>(context, listen: false).loadUser();
        debugPrint('Splash: User data loaded');
      }
    } catch (e) {
      debugPrint('Splash Error: $e');
    }
    
    // Splash delay
    await Future.delayed(const Duration(milliseconds: 2500));
    debugPrint('Splash: Delay finished');
    
    if (mounted) {
      final user = Provider.of<UserProvider>(context, listen: false);
      debugPrint('Splash: User ID: ${user.id}');
      if (user.id != null) {
        debugPrint('Splash: Navigating to MainWrapper');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainWrapper())
        );
      } else {
        debugPrint('Splash: Navigating to LoginScreen');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen())
        );
      }
    }
  }

  @override
  void dispose() {
    _zoomController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Stack(
        children: [
          ...List.generate(20, (index) => _buildConfettiParticle(index)),
          Center(
            child: ScaleTransition(
              scale: _zoomAnimation,
              child: FadeInDown(
                duration: const Duration(milliseconds: 1000),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Shot',
                        style: GoogleFonts.plusJakartaSans(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -2),
                      ),
                      TextSpan(
                        text: 'Spot',
                        style: GoogleFonts.plusJakartaSans(fontSize: 48, fontWeight: FontWeight.w900, color: const Color(0xFFE91E63), letterSpacing: -2),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfettiParticle(int index) {
    return FadeOutDown(
      delay: Duration(milliseconds: index * 100),
      duration: const Duration(milliseconds: 2000),
      child: Align(
        alignment: Alignment(
          (index % 5 - 2) * 0.4,
          -1.2,
        ),
        child: Container(
          width: 8, height: 8,
          decoration: BoxDecoration(
            color: index % 2 == 0 ? const Color(0xFFE91E63) : Colors.amber,
            shape: index % 3 == 0 ? BoxShape.circle : BoxShape.rectangle,
          ),
        ),
      ),
    );
  }
}
