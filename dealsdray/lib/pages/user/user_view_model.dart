import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final String? name;
  final String? email;
  final String? phone;

  User({this.name, this.email, this.phone});
}

class UserViewModel extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  UserViewModel() {
    _loadUserData();
  }

  String extractUserName(String email) {
    String username = email.split('@')[0];
    return username
        .replaceAll('.', ' ')
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _user = User(
      name: extractUserName(prefs.getString('user_email').toString()) ?? 'John Doe',
      email: prefs.getString('user_email') ?? 'john.doe@example.com',
      phone: prefs.getString('mobileNumber') ?? 'N/A',
    );
    notifyListeners();
  }

  Future<void> setUserData({String? name, String? email, String? phone}) async {
    final prefs = await SharedPreferences.getInstance();
    if (name != null) await prefs.setString('user_name', name);
    if (email != null) await prefs.setString('user_email', email);
    if (phone != null) await prefs.setString('user_phone', phone);
    _user = User(
      name: name ?? _user?.name,
      email: email ?? _user?.email,
      phone: phone ?? _user?.phone,
    );
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _user = null;
    notifyListeners();
  }
}