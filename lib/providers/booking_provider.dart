import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BookingProvider with ChangeNotifier {
  List<dynamic> _eventTypes = [];
  List<dynamic> _vendors = [];
  Map<String, dynamic>? _selectedVendorDetails;
  bool _isLoading = false;
  
  // Selection state
  Map<String, dynamic>? _selectedEvent;
  String? _selectedCategory; // Influencer, Photographer, etc.

  List<dynamic> get eventTypes => _eventTypes;
  List<dynamic> get vendors => _vendors;
  Map<String, dynamic>? get selectedVendorDetails => _selectedVendorDetails;
  bool get isLoading => _isLoading;
  Map<String, dynamic>? get selectedEvent => _selectedEvent;
  String? get selectedCategory => _selectedCategory;

  Future<void> fetchEventTypes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _eventTypes = await ApiService.getEventTypes();
    } catch (e) {
      debugPrint('Error fetching event types: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVendors() async {
    _isLoading = true;
    notifyListeners();

    try {
      _vendors = await ApiService.getVendors();
    } catch (e) {
      debugPrint('Error fetching vendors: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchVendorDetails(String id) async {
    _isLoading = true;
    _selectedVendorDetails = null;
    notifyListeners();

    try {
      _selectedVendorDetails = await ApiService.getVendorDetails(id);
    } catch (e) {
      debugPrint('Error fetching vendor details: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<String> _busyDates = [];
  List<String> get busyDates => _busyDates;

  Future<void> fetchBusyDates(String vendorId) async {
    _busyDates = [];
    try {
      final data = await ApiService.getBusyDates(vendorId);
      _busyDates = data.map((e) => e.toString()).toList();
    } catch (e) {
      debugPrint('Error fetching busy dates: $e');
    }
    notifyListeners();
  }

  Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    final success = await ApiService.createBooking(bookingData);
    return success;
  }

  void selectEvent(Map<String, dynamic> event) {
    _selectedEvent = event;
    notifyListeners();
  }


  List<dynamic> _userBookings = [];
  List<dynamic> get userBookings => _userBookings;

  Future<void> fetchUserBookings(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _userBookings = await ApiService.getUserBookings(userId);
    } catch (e) {
      debugPrint('Error fetching user bookings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }
}
