import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'otp_screen.dart';

import '../../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  void _handleGetOtp() async {
    if (_phoneController.text.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter valid phone number')));
      return;
    }
    setState(() => _isLoading = true);
    try {
      final res = await ApiService.sendOtp(_phoneController.text);
      if (res != null && res['message'] == 'OTP sent successfully') {
        Navigator.push(context, MaterialPageRoute(builder: (_) => OtpScreen(phone: _phoneController.text)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res?['message'] ?? 'Error sending OTP')));
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 120),
              FadeInDown(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'Welcome to\n', style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2)),
                      TextSpan(text: 'Shot', style: GoogleFonts.plusJakartaSans(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white)),
                      TextSpan(text: 'Spot', style: GoogleFonts.plusJakartaSans(fontSize: 48, fontWeight: FontWeight.w900, color: const Color(0xFFE91E63))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              FadeInDown(
                delay: const Duration(milliseconds: 200),
                child: Text('Book world-class talent in seconds', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16)),
              ),
              const SizedBox(height: 60),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mobile Number', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 15),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.1))),
                      child: Row(
                        children: [
                          const Text('+91', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 15),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(hintText: 'Enter your number', hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)), border: InputBorder.none),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: GestureDetector(
                  onTap: _isLoading ? null : _handleGetOtp,
                  child: Container(
                    width: double.infinity, height: 60,
                    decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF5252)]), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: const Color(0xFFE91E63).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]),
                    child: Center(
                      child: _isLoading 
                        ? const CircularProgressIndicator(color: Colors.white) 
                        : const Text('Get OTP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
