import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../backendProperties.dart';

class RegisterViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  Future<bool> registerUser(String email, String password, String referralCode, String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final payload = {
        "email": email,
        "password": password,
        "referralCode": referralCode,
        "userId": userId,
      };

      final response = await http.post(
        Uri.parse(BackendProperties.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}