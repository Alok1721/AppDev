import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../backendProperties.dart';

class SplashViewModel extends ChangeNotifier {
  bool isLoading = true;
  String? errorMessage;

  Future<bool> checkDeviceRegistration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      bool isDeviceRegistered = prefs.getBool('isDeviceRegistered') ?? false;

      if (!isDeviceRegistered) {
        await _registerDevice();
        await prefs.setBool('isDeviceRegistered', true);
      }

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      errorMessage = _getFriendlyErrorMessage(e);
      notifyListeners();
      return false;
    }
  }

  Future<void> _registerDevice() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      Position position = await _determinePosition();

      final payload = {
        "deviceType": "android",
        "deviceId": androidInfo.id,
        "deviceName": "${androidInfo.manufacturer}-${androidInfo.model}",
        "deviceOSVersion": androidInfo.version.release,
        "deviceIPAddress": await _getDeviceIPAddress() ?? 'unknown',
        "lat": position.latitude,
        "long": position.longitude,
        "buyer_gcmid": "",
        "buyer_pemid": "",
        "app": {
          "version": packageInfo.version,
          "installTimeStamp": DateTime.now().toIso8601String(),
          "uninstallTimeStamp": DateTime.now().toIso8601String(),
          "downloadTimeStamp": DateTime.now().toIso8601String(),
        }
      };

      final response = await http.post(
        Uri.parse(BackendProperties.deviceAdd),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        throw Exception('Server error: Unable to register device. ${response.body}');
      }
    } catch (e) {
      throw Exception('Error registering device: $e');
    }
  }

  Future<String?> _getDeviceIPAddress() async {
    try {
      // Placeholder: Use network_info_plus for real IP
      return '192.168.1.1'; // Replace with actual IP fetching logic
    } catch (e) {
      debugPrint('Error fetching IP: $e');
      return null;
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Please enable location services.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Please grant location permissions.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  String _getFriendlyErrorMessage(dynamic error) {
    if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    } else if (error.toString().contains('location services')) {
      return 'Location services are disabled. Please enable them.';
    } else if (error.toString().contains('permissions')) {
      return 'Location permissions are required. Please grant them.';
    }
    return 'An error occurred. Please try again.';
  }
}