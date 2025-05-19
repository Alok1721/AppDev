import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../backendProperties.dart';

enum OtpVerificationResult { success, newUser, error }

class OtpVerificationViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  String? userId;

  void setErrorMessage(String message) {
    errorMessage = message;
    notifyListeners();
  }

  void clearErrorMessage() {
    if (errorMessage != null) {
      errorMessage = null;
      notifyListeners();
    }
  }

  Future<OtpVerificationResult> verifyOtp(String otp, String deviceId, String userId) async {
    if (otp.length != 4 || !RegExp(r'^\d{4}$').hasMatch(otp)) {
      setErrorMessage('Please enter a valid 4-digit OTP');
      return OtpVerificationResult.error;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final payload = {
        "otp": otp,
        "deviceId": deviceId,
        "userId": userId,
      };

      final response = await http.post(
        Uri.parse(BackendProperties.otpVerify),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        this.userId = userId; // Persist userId for registration
        return OtpVerificationResult.success;
      } else if (response.statusCode == 400 || response.statusCode == 403) {
        this.userId = userId; // Persist userId for registration
        return OtpVerificationResult.newUser;
      } else {
        throw Exception('Failed to verify OTP: ${response.statusCode}');
      }
    } catch (e) {
      setErrorMessage(_getFriendlyErrorMessage(e));
      return OtpVerificationResult.error;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resendOtp(String mobileNumber, String deviceId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final payload = {
        "mobileNumber": mobileNumber,
        "deviceId": deviceId,
      };

      final response = await http.post(
        Uri.parse(BackendProperties.otpRequest),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1 && data['data'] != null) {
          userId = data['data']['userId'];
          return true;
        } else {
          throw Exception('Invalid OTP resend response format');
        }
      } else {
        throw Exception('Failed to resend OTP: ${response.statusCode}');
      }
    } catch (e) {
      setErrorMessage(_getFriendlyErrorMessage(e));
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _getFriendlyErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    } else if (error.toString().contains('Failed to verify OTP')) {
      return 'Invalid OTP. Please try again.';
    }
    return 'An error occurred. Please try again.';
  }
}