import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isLoading = false;

  void _sendOtp() async {
    setState(() => _isLoading = true);
    try {
      // For now, our backend /send-otp uses Fast2SMS. 
      // If you don't have keys yet, it might fail, so handle accordingly.
      final res = await ApiService.login(_phoneController.text, "1234"); // Mocking for now if needed
      // Actually let's just use verify-otp directly if we want to bypass send-otp for testing
      setState(() => _isOtpSent = true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _verifyOtp() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiService.login(_phoneController.text, _otpController.text);
      if (res['token'] != null) {
        ApiService.setToken(res['token']);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'] ?? 'Login failed')));
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
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back,', style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.w900)),
            Text('Sign in to manage your shoots', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            const SizedBox(height: 40),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: 'Phone Number',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            if (_isOtpSent)
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  hintText: 'OTP',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                ),
              ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isLoading ? null : (_isOtpSent ? _verifyOtp : _sendOtp),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white) 
                  : Text(_isOtpSent ? 'Verify OTP' : 'Send OTP', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
