import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../backendProperties.dart';

class OtpVerificationViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  String? userId;

  Future<bool> verifyOtp(String otp, String deviceId, String mobileNumber) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final payload = {
        "otp": otp,
        "deviceId": deviceId,
        "userId": "62b43547c84bb6dac82e0525", // Hardcoded as per your example
      };

      final response = await http.post(
        Uri.parse(BackendProperties.otpVerify),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        userId = data['userId'] ?? payload['userId'];
        return true;
      } else {
        throw Exception('Failed to verify OTP: ${response.body}');
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