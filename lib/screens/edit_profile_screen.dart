import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false);
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
    _locationController = TextEditingController(text: user.location);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final location = _locationController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name cannot be empty')));
      return;
    }

    setState(() => _isLoading = true);
    
    final success = await ApiService.updateProfile(
      name: name,
      email: email.isEmpty ? null : email,
      location: location.isEmpty ? null : location,
    );

    if (success) {
      if (mounted) {
        await Provider.of<UserProvider>(context, listen: false).updateProfile(
          name: name,
          email: email.isEmpty ? null : email,
          location: location.isEmpty ? null : location,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile. Please try again.')),
        );
      }
    }
    
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final user = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFFBFBFB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Your Profile', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, color: isDark ? Colors.white : Colors.black)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_rounded, color: isDark ? Colors.white : Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  _buildAvatar(user, isDark),
                  Positioned(
                    bottom: 0, 
                    right: 0, 
                    child: Container(
                      padding: const EdgeInsets.all(8), 
                      decoration: const BoxDecoration(color: Color(0xFFE91E63), shape: BoxShape.circle), 
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20)
                    )
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildTextField('Full Name', _nameController, isDark, Icons.person_outline_rounded),
            _buildTextField('Email (Optional)', _emailController, isDark, Icons.email_outlined),
            _buildTextField('Phone', _phoneController, isDark, Icons.phone_outlined, enabled: false),
            _buildTextField('Location', _locationController, isDark, Icons.location_on_outlined),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _isLoading ? null : _saveChanges,
              child: Container(
                width: double.infinity, 
                height: 65,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF5252)]),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFE91E63).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))
                  ]
                ),
                child: Center(
                  child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Save Changes', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18))
                ),
              ),
            )
          ],
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
        gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF5252)]),
      ),
      child: Center(child: Text(initials.isEmpty ? 'U' : initials, style: GoogleFonts.plusJakartaSans(fontSize: 40, fontWeight: FontWeight.w800, color: Colors.white))),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isDark, IconData icon, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: TextField(
        controller: controller,
        enabled: enabled,
        style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: const Color(0xFFE91E63), size: 20),
          labelStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500),
          filled: true,
          fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey[200]!)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Color(0xFFE91E63), width: 2)),
          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: isDark ? Colors.white10 : Colors.grey[100]!)),
        ),
      ),
    );
  }
}
