import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/services.dart';
import 'registration_screen.dart';
import '../../main.dart';

import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../services/api_service.dart';

class OtpScreen extends StatefulWidget {
  final String phone;
  const OtpScreen({super.key, required this.phone});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(4, (index) => TextEditingController());
  bool _isLoading = false;

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _handleVerify() async {
    String otp = _controllers.map((c) => c.text).join();
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter 4-digit OTP')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final res = await ApiService.verifyOtp(widget.phone, otp);
      if (res != null && res['token'] != null) {
        await ApiService.setToken(res['token']);
        if (mounted) {
          await Provider.of<UserProvider>(context, listen: false).setUser(res);
        }
        
        if (res['isNewUser'] == true) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => RegistrationScreen(phone: widget.phone))
          );
        } else {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const MainWrapper()), 
            (route) => false
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res?['message'] ?? 'Invalid OTP')));
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
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            FadeInDown(child: Text('Verification', style: GoogleFonts.plusJakartaSans(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white))),
            const SizedBox(height: 10),
            FadeInDown(delay: const Duration(milliseconds: 200), child: Text('We have sent a 4-digit code to your mobile number +91 ${widget.phone}', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14))),
            const SizedBox(height: 50),
            FadeInUp(
              delay: const Duration(milliseconds: 400),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => _buildOtpBox(index)),
              ),
            ),
            const SizedBox(height: 40),
            FadeInUp(
              delay: const Duration(milliseconds: 600),
              child: GestureDetector(
                onTap: _isLoading ? null : _handleVerify,
                child: Container(
                  width: double.infinity, height: 60,
                  decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFFE91E63), Color(0xFFFF5252)]), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: const Color(0xFFE91E63).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))]),
                  child: Center(
                    child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white) 
                      : const Text('Verify & Proceed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Center(child: Text('Resend code in 00:29', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13))),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBox(int index) {
    return Container(
      width: 70, height: 75,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: _focusNodes[index].hasFocus ? const Color(0xFFE91E63) : Colors.white.withOpacity(0.1), width: 2)),
      child: Center(
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center, keyboardType: TextInputType.number,
          inputFormatters: [LengthLimitingTextInputFormatter(1), FilteringTextInputFormatter.digitsOnly],
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          decoration: const InputDecoration(border: InputBorder.none, hintText: '0', hintStyle: TextStyle(color: Colors.white10)),
          onChanged: (value) => _onChanged(value, index),
        ),
      ),
    );
  }
}
