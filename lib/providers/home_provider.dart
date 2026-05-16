import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeProvider with ChangeNotifier {
  List<dynamic> _categories = [];
  List<dynamic> _banners = [];
  List<dynamic> _shots = [];
  List<dynamic> _combos = [];
  List<dynamic> _talents = [];
  bool _isLoading = false;

  List<dynamic> get categories => _categories;
  List<dynamic> get banners => _banners;
  List<dynamic> get shots => _shots;
  List<dynamic> get combos => _combos;
  List<dynamic> get talents => _talents;
  bool get isLoading => _isLoading;

  Future<void> fetchHomeData() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final results = await Future.wait([
        ApiService.getCategories(),
        ApiService.getHomeContent(),
      ]);
      
      _categories = results[0] as List<dynamic>;
      
      final homeContent = results[1] as Map<String, dynamic>;
      _banners = homeContent['banners'] ?? [];
      _shots = homeContent['shots'] ?? [];
      _combos = homeContent['combos'] ?? [];
      _talents = homeContent['talents'] ?? [];
      
    } catch (e) {
      debugPrint('HomeProvider Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
