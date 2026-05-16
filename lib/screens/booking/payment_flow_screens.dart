import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../../providers/cart_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/api_service.dart';
import '../order_details_screen.dart';
import '../../main.dart';

class PaymentProcessingScreen extends StatefulWidget {
  final double amount;
  const PaymentProcessingScreen({super.key, required this.amount});

  @override
  State<PaymentProcessingScreen> createState() => _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState extends State<PaymentProcessingScreen> {
  late Razorpay _razorpay;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    
    // Step 1: Create order on server then open Razorpay
    _initiateRealPayment();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> _initiateRealPayment() async {
    setState(() => _isInitializing = true);
    
    // Call Backend to create Order
    final order = await ApiService.createPaymentOrder(widget.amount);
    
    if (order == null || order['id'] == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to initialize payment. Try again.')),
        );
        Navigator.pop(context);
      }
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    
    var options = {
      'key': 'rzp_test_RGazN4NcB5huki', // MATCHING .ENV KEY
      'amount': order['amount'], 
      'name': 'ShotSpot',
      'order_id': order['id'], // REAL ORDER ID FROM SERVER
      'description': 'Booking Professional Services',
      'prefill': {
        'contact': userProvider.phone ?? '9999999999',
        'email': 'customer@example.com'
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      setState(() => _isInitializing = false);
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _verifyAndProcessBooking(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Failed: ${response.message}')),
      );
      Navigator.pop(context);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint("External Wallet: ${response.walletName}");
  }

  Future<void> _verifyAndProcessBooking(PaymentSuccessResponse response) async {
    setState(() => _isInitializing = true); // Show loader during verification

    // Step 2: Verify signature on server
    final isVerified = await ApiService.verifyPayment({
      'razorpay_order_id': response.orderId,
      'razorpay_payment_id': response.paymentId,
      'razorpay_signature': response.signature,
    });

    if (!isVerified) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment verification failed!')),
        );
        Navigator.pop(context);
      }
      return;
    }

    // Step 3: Create Bookings
    final cart = Provider.of<CartProvider>(context, listen: false);
    final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    bool allSuccess = true;
    for (var item in cart.items) {
      final success = await bookingProvider.createBooking({
        'user': userProvider.id,
        'vendor': item.id,
        'date': DateFormat('yyyy-MM-dd').format(item.date),
        'startTime': item.time,
        'duration': item.hours,
        'paymentId': response.paymentId,
        'orderId': response.orderId,
        'totalAmount': double.parse(item.price.replaceAll('\u20B9', '').replaceAll('/hr', '').replaceAll(',', '')) * item.hours,
      });
      if (!success) allSuccess = false;
    }

    if (mounted) {
      if (allSuccess) {
        cart.clearCart();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PaymentSuccessScreen(amount: widget.amount, transactionId: response.paymentId ?? 'N/A')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Verified but booking failed. Contact support.')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeInDown(
              child: Container(
                height: 80, width: 80,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(color: const Color(0xFFE91E63).withOpacity(0.05), shape: BoxShape.circle),
                child: const Icon(Icons.security_rounded, size: 40, color: Color(0xFFE91E63)),
              ),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              height: 40, width: 40,
              child: CircularProgressIndicator(strokeWidth: 3, color: Color(0xFFE91E63), strokeCap: StrokeCap.round),
            ),
            const SizedBox(height: 30),
            Text(
              _isInitializing ? 'Securing Transaction...' : 'Redirecting to Razorpay...',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18)
            ),
            const SizedBox(height: 10),
            Text('\u20B9${widget.amount.toStringAsFixed(2)} • Standard Payment', style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class PaymentSuccessScreen extends StatelessWidget {
  final double amount;
  final String transactionId;
  const PaymentSuccessScreen({super.key, required this.amount, required this.transactionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ZoomIn(
                child: Container(
                  height: 110, width: 110,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF81C784)]),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: Color(0xFF4CAF50), blurRadius: 20, offset: Offset(0, 10))],
                  ),
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 55),
                ),
              ),
              const SizedBox(height: 45),
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Text('Payment Successful!', style: GoogleFonts.plusJakartaSans(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
              ),
              const SizedBox(height: 10),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Text('Your creative journey begins now.', style: TextStyle(color: Colors.grey[500], fontSize: 15, fontWeight: FontWeight.w500)),
              ),
              const SizedBox(height: 50),
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10))],
                    border: Border.all(color: Colors.black.withOpacity(0.02)),
                  ),
                  child: Column(
                    children: [
                      _rowInfo('Transaction ID', transactionId),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1, color: Color(0xFFF5F5F5))),
                      _rowInfo('Amount Paid', '\u20B9${amount.toStringAsFixed(2)}'),
                      const Padding(padding: EdgeInsets.symmetric(vertical: 15), child: Divider(height: 1, color: Color(0xFFF5F5F5))),
                      _rowInfo('Status', 'Success', isStatus: true),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
              FadeInUp(
                delay: const Duration(milliseconds: 600),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainWrapper(initialIndex: 3)),
                      (route) => false,
                    );
                  },
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 10))],
                    ),
                    child: const Center(child: Text('Return to Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 17))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowInfo(String label, String val, {bool isStatus = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w700, fontSize: 13)),
        Text(val, style: TextStyle(fontWeight: FontWeight.w900, color: isStatus ? const Color(0xFF4CAF50) : Colors.black, fontSize: 14)),
      ],
    );
  }
}
