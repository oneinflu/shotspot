import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../../main.dart';
import '../../services/api_service.dart';
import '../../providers/user_provider.dart';

class RegistrationScreen extends StatefulWidget {
  final String phone;
  const RegistrationScreen({super.key, required this.phone});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  void _handleRegister() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter your full name')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      // Pass phone along with profile update since we don't have middleware yet
      await ApiService.updateProfile(
        name: _nameController.text.trim(), 
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      );
      
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).updateProfile(
          name: _nameController.text.trim(), 
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        );
        
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainWrapper()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 100),
            FadeInDown(
              child: Text(
                'Complete your\nProfile',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 40),
            _buildInput('Full Name', _nameController, Icons.person_outline),
            const SizedBox(height: 20),
            _buildInput(
              'Email Address', 
              _emailController, 
              Icons.email_outlined, 
              helper: 'Optional - for recovery & updates',
            ),
            const SizedBox(height: 20),
            _buildInput('Phone Number', TextEditingController(text: '+91 ${widget.phone}'), Icons.phone_android, enabled: false),
            const SizedBox(height: 50),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: GestureDetector(
                onTap: _isLoading ? null : _handleRegister,
                child: Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF5252)]),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFE91E63).withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Start Exploring',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon, {bool enabled = true, String? helper}) {
    return FadeInUp(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w600),
              ),
              if (helper != null)
                Text(
                  helper,
                  style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 11, fontWeight: FontWeight.w400),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TextField(
              controller: controller,
              enabled: enabled,
              style: TextStyle(color: enabled ? Colors.white : Colors.white54, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                icon: Icon(icon, color: const Color(0xFFE91E63), size: 20),
                border: InputBorder.none,
                hintText: 'Enter $label',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.1)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
