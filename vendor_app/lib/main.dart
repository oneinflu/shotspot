import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/vendor_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VendorProvider()),
      ],
      child: const ShotSpotVendorApp(),
    ),
  );
}

class ShotSpotVendorApp extends StatelessWidget {
  const ShotSpotVendorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ShotSpot Vendor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color(0xFFFBFBFB),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: const LoginScreen(),
    );
  }
}
