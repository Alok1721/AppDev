// import 'dart:io';
// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter/foundation.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../../../backendProperties.dart';
//
// class LoginViewModel extends ChangeNotifier {
//   bool isLoading = false;
//   String? errorMessage;
//   String? deviceId;
//   String? userId;
//   bool userExists = false;
//   int currentTab = 0; // 0 for Phone, 1 for Email
//
//   LoginViewModel() {
//     _initializeDeviceId();
//   }
//
//   void updateTab(int tabIndex) {
//     if (currentTab != tabIndex) {
//       currentTab = tabIndex;
//       errorMessage = null;
//       notifyListeners();
//     }
//   }
//
//   Future<void> _initializeDeviceId() async {
//     deviceId = await getDeviceId();
//     notifyListeners();
//   }
//
//   Future<String> getDeviceId() async {
//     final deviceInfo = DeviceInfoPlugin();
//     try {
//       if (Platform.isAndroid) {
//         final androidInfo = await deviceInfo.androidInfo;
//         return androidInfo.id;
//       } else if (Platform.isIOS) {
//         final iosInfo = await deviceInfo.iosInfo;
//         return iosInfo.identifierForVendor ?? 'ios-fallback-id';
//       }
//     } catch (e) {
//       print('Error fetching device ID: $e');
//     }
//     return 'fallback-device-id';
//   }
//
//   Future<bool> requestOtpWithPhone(String mobileNumber) async {
//     isLoading = true;
//     errorMessage = null;
//     currentTab = 0;
//     notifyListeners();
//
//     try {
//       final payload = {
//         "mobileNumber": mobileNumber,
//         "deviceId": deviceId,
//       };
//
//       final response = await http.post(
//         Uri.parse(BackendProperties.otpRequest),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(payload),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         deviceId = data['deviceId'] ?? payload['deviceId'];
//         return true;
//       } else {
//         throw Exception('Failed to request OTP: ${response.body}');
//       }
//     } catch (e) {
//       errorMessage = 'Failed to send OTP. Please check your number.';
//       return false;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   Future<bool> registerOrLoginEmail(String email, String password, String referralCode) async {
//     isLoading = true;
//     errorMessage = null;
//     currentTab = 1;
//     notifyListeners();
//
//     try {
//       final payload = {
//         "email": email,
//         "password": password,
//         "referralCode": int.tryParse(referralCode) ?? 0,
//         "userId": userId ?? "62a833766ec5dafd6780fc85", // Fallback to static userId
//       };
//
//       final response = await http.post(
//         Uri.parse(BackendProperties.register),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(payload),
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         userExists = data["data"]["userExists"] ?? false;
//         userId = data["data"]["userId"] ?? payload["userId"];
//         return true;
//       } else {
//         throw Exception('Failed to login/register: ${response.body}');
//       }
//     } catch (e) {
//       errorMessage = 'Login failed. Please check your credentials.';
//       return false;
//     } finally {
//       isLoading = false;
//       notifyListeners();
//     }
//   }
// }