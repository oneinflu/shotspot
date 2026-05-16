import 'package:flutter/material.dart';
import '../services/api_service.dart';

class VendorProvider with ChangeNotifier {
  Map<String, dynamic>? _stats;
  List<dynamic> _shoots = [];
  bool _isLoading = false;

  Map<String, dynamic>? get stats => _stats;
  List<dynamic> get shoots => _shoots;
  bool get isLoading => _isLoading;

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _stats = await ApiService.getVendorStats();
      _shoots = await ApiService.getVendorShoots();
    } catch (e) {
      print('Error fetching dashboard data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
