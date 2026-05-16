import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';
import 'auth/login_screen.dart';
import 'edit_profile_screen.dart';
import 'payment_methods_screen.dart';
import 'info_detail_screen.dart';
import 'notifications_screen.dart';
import 'orders_screen.dart';
import 'invite_friends_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final bool isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
        leading: Navigator.canPop(context) ? IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : const Color(0xFF1A1A1A)),
        ) : null,
        actions: const [SizedBox(width: 15)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),
            FadeInDown(
              child: Center(
                child: Column(
                  children: [
                    _buildAvatar(userProvider, isDark),
                    const SizedBox(height: 20),
                    Text(
                      userProvider.name ?? 'New User',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      userProvider.phone ?? 'No phone linked',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    if (userProvider.location != null && userProvider.location!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on_rounded, size: 14, color: Color(0xFFE91E63)),
                          const SizedBox(width: 4),
                          Text(
                            userProvider.location!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ],

                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildMenuItem(Icons.shopping_bag_outlined, 'My Orders', isDark, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const OrdersScreen()));
            }),
            _buildMenuItem(Icons.person_outline_rounded, 'Your Profile', isDark, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
            }),


            _buildMenuItem(Icons.privacy_tip_outlined, 'Privacy Policy', isDark, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoDetailScreen(title: 'Privacy Policy')));
            }),
            _buildMenuItem(Icons.description_outlined, 'Terms and Conditions', isDark, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoDetailScreen(title: 'Terms and Conditions')));
            }),
            _buildMenuItem(Icons.help_outline_rounded, 'Help Center', isDark, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InfoDetailScreen(title: 'Help Center')));
            }),
            _buildMenuItem(Icons.person_add_outlined, 'Invite Friends', isDark, () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const InviteFriendsScreen()));
            }),
            const SizedBox(height: 20),
            FadeInUp(
              child: ListTile(
                onTap: () async {
                  await ApiService.clearAuth();
                  await userProvider.logout();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  }
                },
                leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: Text(
                  'Log Out',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, bool isDark, VoidCallback onTap) {
    return FadeInUp(
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: isDark ? Colors.white70 : const Color(0xFF1A1A1A)),
          title: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1A1A1A),
            ),
          ),
          trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
        ),
      ),
    );
  }

  Widget _buildAvatar(UserProvider user, bool isDark) {
    if (user.profilePic != null && user.profilePic!.isNotEmpty) {
      return Container(
        height: 120, width: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE91E63), width: 3),
          image: DecorationImage(image: NetworkImage(user.profilePic!), fit: BoxFit.cover),
        ),
      );
    }

    final name = user.name ?? 'User';
    final initials = name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join().toUpperCase();

    return Container(
      height: 120, width: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE91E63), width: 3),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE91E63), Color(0xFFFF5252)],
        ),
      ),
      child: Center(
        child: Text(
          initials.isEmpty ? 'U' : initials,
          style: GoogleFonts.plusJakartaSans(fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white),
        ),
      ),
    );
  }
}
