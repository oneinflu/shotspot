import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String id;
  final String name;
  final String role;
  final String price;
  final String image;
  final DateTime date;
  final String time;
  final int hours;

  CartItem({
    required this.id,
    required this.name,
    required this.role,
    required this.price,
    required this.image,
    required this.date,
    required this.time,
    required this.hours,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'price': price,
    'image': image,
    'date': date.toIso8601String(),
    'time': time,
    'hours': hours,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    id: json['id'],
    name: json['name'],
    role: json['role'],
    price: json['price'],
    image: json['image'],
    date: DateTime.parse(json['date']),
    time: json['time'],
    hours: json['hours'],
  );
}

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  CartProvider() {
    loadCart();
  }

  Future<void> addToCart(CartItem item) async {
    if (!_items.any((x) => x.id == item.id)) {
      _items.add(item);
      await saveCart();
      notifyListeners();
    }
  }

  Future<void> removeFromCart(String id) async {
    _items.removeWhere((item) => item.id == id);
    await saveCart();
    notifyListeners();
  }

  Future<void> clearCart() async {
    _items.clear();
    await saveCart();
    notifyListeners();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String cartData = jsonEncode(_items.map((item) => item.toJson()).toList());
    await prefs.setString('cart_items', cartData);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartData = prefs.getString('cart_items');
    if (cartData != null) {
      final List<dynamic> decoded = jsonDecode(cartData);
      _items = decoded.map((item) => CartItem.fromJson(item)).toList();
      notifyListeners();
    }
  }

  double _payableAmount = 0.0;
  double get payableAmount => _payableAmount == 0.0 ? totalAmount : _payableAmount;

  set payableAmount(double value) {
    _payableAmount = value;
    notifyListeners();
  }

  double get totalAmount {
    double total = 0.0;
    for (var item in _items) {
      double hourlyRate = double.tryParse(item.price.replaceAll('\u20B9', '').replaceAll(',', '').replaceAll('/hr', '')) ?? 0.0;
      total += hourlyRate * item.hours;
    }
    return total;
  }
}
