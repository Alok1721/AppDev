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
    final prefs = await SharedPreferences.getInstance();
    bool isDeviceRegistered = prefs.getBool('isDeviceRegistered') ?? false;

    if (!isDeviceRegistered) {
      await _registerDevice();
      await prefs.setBool('isDeviceRegistered', true);
    }

    isLoading = false;
    notifyListeners();
    return true;
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
        "deviceIPAddress": "11.433.445.66",
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
        throw Exception('Failed to register device: ${response.body}');
      }
    } catch (e) {
      errorMessage = e.toString();
      throw Exception('Error registering device: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }
}