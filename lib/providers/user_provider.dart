import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _id;
  String? _phone;
  String? _name;
  String? _email;
  String? _profilePic;
  String? _location;

  String? get id => _id;
  String? get phone => _phone;
  String? get name => _name;
  String? get email => _email;
  String? get profilePic => _profilePic;
  String? get location => _location;

  Future<void> setUser(Map<String, dynamic> data) async {
    _id = data['_id'];
    _phone = data['phone'];
    _name = data['name'];
    _email = data['email'];
    _profilePic = data['profilePic'];
    _location = data['location'];
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(data));
    notifyListeners();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      final data = jsonDecode(userData);
      _id = data['_id'];
      _phone = data['phone'];
      _name = data['name'];
      _email = data['email'];
      _profilePic = data['profilePic'];
      _location = data['location'];
      notifyListeners();
    }
  }

  Future<void> updateProfile({String? name, String? email, String? profilePic, String? location}) async {
    if (name != null) _name = name;
    if (email != null) _email = email;
    if (profilePic != null) _profilePic = profilePic;
    if (location != null) _location = location;
    
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      final data = jsonDecode(userData);
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (profilePic != null) data['profilePic'] = profilePic;
      if (location != null) data['location'] = location;
      await prefs.setString('user_data', jsonEncode(data));
    }
    notifyListeners();
  }

  Future<void> logout() async {
    _id = null;
    _phone = null;
    _name = null;
    _email = null;
    _profilePic = null;
    _location = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_data');
    notifyListeners();
  }
}
