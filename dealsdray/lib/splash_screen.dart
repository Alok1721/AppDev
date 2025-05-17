import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkDeviceRegistration();
  }

  Future<void> _checkDeviceRegistration() async {
    final prefs = await SharedPreferences.getInstance();
    bool isDeviceRegistered = prefs.getBool('isDeviceRegistered') ?? false;

    if (!isDeviceRegistered) {
      await _registerDevice();
      await prefs.setBool('isDeviceRegistered', true);
    }

    // Navigate to Dashboard (or Login screen based on your flow)
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  Future<void> _registerDevice() async {
    try {
      // Fetch device info
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      // Fetch location
      Position position = await _determinePosition();

      // Prepare payload
      final payload = {
        "deviceType": "android",
        "deviceId": androidInfo.id,
        "deviceName": "${androidInfo.manufacturer}-${androidInfo.model}",
        "deviceOSVersion": androidInfo.version.release,
        "deviceIPAddress": "11.433.445.66", // Use a package like `network_info_plus` for real IP
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

      // Make API call
      final response = await http.post(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/device/add'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode != 200) {
        // Handle error (e.g., retry or log)
        print('Failed to register device: ${response.body}');
      }
    } catch (e) {
      print('Error registering device: $e');
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Placeholder for your splash image
            Image.asset(
              'assets/splash_image.png', // Replace with your image path
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            const Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
