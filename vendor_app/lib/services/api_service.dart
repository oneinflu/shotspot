import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.29.251:5001/api'; 
  
  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // Auth
  static Future<Map<String, dynamic>> login(String phone, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/verify-otp'),
      body: jsonEncode({'phone': phone, 'otp': otp}),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  // Vendor Stats
  static Future<Map<String, dynamic>> getVendorStats() async {
    final response = await http.get(
      Uri.parse('$baseUrl/vendors/stats'),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }

  // Vendor Shoots
  static Future<List<dynamic>> getVendorShoots() async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings/vendor/shoots'),
      headers: _headers,
    );
    return jsonDecode(response.body);
  }
}
