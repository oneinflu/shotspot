import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'https://shotspotapis-gmylz.ondigitalocean.app/api';
  static String? _token;

  static String? get token => _token;

  // Auth Methods
  static Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
  }

  static Future<Map<String, dynamic>?> sendOtp(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/send-otp'), // Corrected to /users/send-otp
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone}),
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('Error sending OTP: $e');
    }
    return null;
  }

  static Future<Map<String, dynamic>?> verifyOtp(String phone, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/verify-otp'), // Corrected to /users/verify-otp
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'phone': phone, 'otp': otp}),
      );
      return json.decode(response.body);
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
    }
    return null;
  }

  static Future<List<dynamic>> getAvailableVendors(String date, String startTime, int duration) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/vendors/available?date=$date&startTime=$startTime&duration=$duration'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> updateProfile({String? name, String? email, String? profilePic, String? location}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          if (_token != null) 'Authorization': 'Bearer $_token',
        },
        body: json.encode({
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (profilePic != null) 'profilePic': profilePic,
          if (location != null) 'location': location,
        }),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      return false;
    }
  }

  // Home Methods
  static Future<List<dynamic>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services/categories'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>> getHomeContent() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/content/home'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching home content: $e');
    }
    return {};
  }

  // Booking & Vendor Methods
  static Future<List<dynamic>> getEventTypes() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/services/event-types'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching event types: $e');
    }
    return [];
  }

  static Future<List<dynamic>> getVendors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vendors'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching vendors: $e');
    }
    return [];
  }

  static Future<List<dynamic>> getFeaturedVendors() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vendors/featured'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching featured vendors: $e');
    }
    return [];
  }

  static Future<List<dynamic>> getVendorsByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vendors/category/$category'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching vendors by category: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getVendorDetails(String vendorId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/vendors/$vendorId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching vendor details: $e');
    }
    return null;
  }

  static Future<List<dynamic>> getBusyDates(String vendorId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bookings/availability/$vendorId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching busy dates: $e');
    }
    return [];
  }

  static Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(bookingData),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Error creating booking: $e');
      return false;
    }
  }

  // Payment Methods
  static Future<Map<String, dynamic>?> createPaymentOrder(double amount) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payments/create-order'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'amount': amount,
          'receipt': 'receipt_${DateTime.now().millisecondsSinceEpoch}'
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error creating payment order: $e');
    }
    return null;
  }

  static Future<bool> verifyPayment(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payments/verify'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Error verifying payment: $e');
    }
    return false;
  }

  // History & Support Methods
  static Future<List<dynamic>> getUserBookings(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bookings/user/$userId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching user bookings: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getBookingDetails(String bookingId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/bookings/$bookingId'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint('Error fetching booking details: $e');
    }
    return null;
  }

  static Future<bool> submitReview(String bookingId, double rating, String comment) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/bookings/$bookingId/review'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'rating': rating, 'comment': comment}),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Error submitting review: $e');
      return false;
    }
  }

  static Future<void> contactSupport(String orderId) async {
    debugPrint('Contacting support for order: $orderId');
  }

  static Future<void> clearAuth() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
