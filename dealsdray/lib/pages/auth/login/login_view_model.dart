import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../backendProperties.dart';

class LoginViewModel extends ChangeNotifier {
  int currentTab = 0;
  bool isLoading = false;
  String? errorMessage;
  String? deviceId;
  String? userId;
  bool switchToPhoneTab = false; // Flag to trigger tab switch

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final referralController = TextEditingController();

  LoginViewModel() {
    _initializeDeviceId();
  }

  void updateTab(int index) {
    if (currentTab != index) {
      currentTab = index;
      if (!switchToPhoneTab) {
        errorMessage = null;
      }
      switchToPhoneTab = false; // Reset tab switch flag
      notifyListeners();
    }
  }

  void setErrorMessage(String message) {
    errorMessage = message;
    debugPrint('setErrorMessage: $message');
    notifyListeners();
  }

  void clearErrorMessage() {
    if (errorMessage != null) {
      errorMessage = null;
      debugPrint('clearErrorMessage');
      notifyListeners();
    }
  }

  Future<void> _initializeDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? 'ios-fallback-id';
      }
    } catch (e) {
      debugPrint('Error fetching device ID: $e');
      deviceId = 'fallback-device-id';
    }
    notifyListeners();
  }

  // Save data to SharedPreferences
  Future<void> _saveToSharedPreferences(String userId, String mobileNumber, String deviceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userId', userId);
    await prefs.setString('mobileNumber', mobileNumber);
    await prefs.setString('deviceId', deviceId);
    debugPrint('Saved to SharedPreferences: userId=$userId, mobileNumber=$mobileNumber, deviceId=$deviceId');
  }Future<void> _saveEmailToSharedPreferences( String user_email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_email', user_email);
    debugPrint('Saved to SharedPreferences: user_email=$user_email');
  }


  // Retrieve data from SharedPreferences
  Future<Map<String, String?>> _getFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'userId': prefs.getString('userId'),
      'mobileNumber': prefs.getString('mobileNumber'),
      'deviceId': prefs.getString('deviceId'),
    };
  }

  Future<String?> requestOtpWithPhone() async {
    if (phoneController.text.trim().length != 10 || !RegExp(r'^\d{10}$').hasMatch(phoneController.text.trim())) {
      errorMessage = 'Please enter a valid 10-digit mobile number';
      notifyListeners();
      return null;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final payload = {
        "mobileNumber": phoneController.text.trim(),
        "deviceId": deviceId ?? 'fallback-device-id',
      };

      debugPrint('Requesting OTP with payload: $payload');

      final response = await http.post(
        Uri.parse(BackendProperties.otpRequest),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      debugPrint('OTP response: ${response.statusCode} ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1 && data['data'] != null) {
          deviceId = data['data']['deviceId'] ?? payload['deviceId'];
          userId = data['data']['userId'];
          if (userId == null) {
            throw Exception('verify your mobile phone');
          }
          // Save to SharedPreferences
          await _saveToSharedPreferences(
            userId!,
            phoneController.text.trim(),
            deviceId!,
          );
          debugPrint('OTP request successful: userId=$userId, deviceId=$deviceId');
          return data['data']['message'] ?? 'OTP sent successfully';
        } else {
          throw Exception('Invalid OTP response format');
        }
      } else {
        throw Exception('Failed to request OTP: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage = _getFriendlyErrorMessage(e);
      debugPrint('OTP request error: $e');
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> registerOrLoginEmail() async {
    // Check if userId and mobileNumber exist in SharedPreferences
    final prefsData = await _getFromSharedPreferences();
    final storedUserId = prefsData['userId'];
    final storedMobileNumber = prefsData['mobileNumber'];
    await _saveEmailToSharedPreferences(emailController.text.toString());


    if (storedUserId == null || storedMobileNumber == null) {
      errorMessage = 'Please verify your mobile first';
      switchToPhoneTab = true; // Trigger tab switch
      notifyListeners();
      return null;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text.trim())) {
      errorMessage = 'Please enter a valid email address';
      notifyListeners();
      return null;
    }
    if (passwordController.text.trim().length < 6) {
      errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return null;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final payload = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "referralCode": int.tryParse(referralController.text.trim()) ?? 0,
        "userId": storedUserId,
      };

      final response = await http.post(
        Uri.parse(BackendProperties.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        return 'Logged in / Registered successfully';
      } else {
        throw Exception('Failed to login/register: ${response.statusCode}');
      }
    } catch (e) {
      errorMessage = _getFriendlyErrorMessage(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String _getFriendlyErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    }
    return 'An error occurred. Please try again.';
  }

  void disposeControllers() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    referralController.dispose();
  }
}