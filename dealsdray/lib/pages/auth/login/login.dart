import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../backendProperties.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  TabController? _tabController;
  bool _isLoading = false;
  String? _errorMessage;
  String _deviceId = "fallback-device-id"; // Initial value

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      // setState(() {
      //   _errorMessage = null; // Clear error when switching tabs
      // });
    });
    _initializeDeviceId();
  }

  Future<void> _initializeDeviceId() async {
    final deviceId = await getDeviceId();
    // setState(() {
    //   _deviceId = deviceId;
    // });
  }

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'ios-fallback-id';
      }
    } catch (e) {
      print('Error fetching device ID: $e');
    }
    return 'fallback-device-id';
  }

  Future<void> _requestOtpWithPhone() async {
    if (_phoneController.text.length != 10 || !RegExp(r'^\d{10}$').hasMatch(_phoneController.text)) {
      // setState(() {
      //   _errorMessage = "Please enter a valid 10-digit mobile number";
      // });
      return;
    }

    // setState(() {
    //   _isLoading = true;
    //   _errorMessage = null;
    // });

    try {
      final response = await http.post(
        Uri.parse(BackendProperties.otpRequest),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "mobileNumber": _phoneController.text,
          "deviceId": _deviceId,
        }),
      );

      if (response.statusCode == 200) {
        // Since API returns no body, assume success and navigate
        Navigator.pushNamed(
          context,
          '/otp_verification',
          arguments: {
            'mobileNumber': _phoneController.text,
            'deviceId': _deviceId,
          },
        );
      } else {
        // setState(() {
        //   _errorMessage = "Failed to send OTP. Please try again.";
        // });
      }
    } catch (e) {
      // setState(() {
      //   _errorMessage = "Error sending OTP: $e";
      // });
    } finally {
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  void _redirectToRegister() {
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text)) {
      setState(() {
        _errorMessage = "Please enter a valid email address";
      });
      return;
    }

    // setState(() {
    //   _errorMessage = null;
    // });

    Navigator.pushNamed(
      context,
      '/register',
      arguments: {'email': _emailController.text},
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("LoginPage build");
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const _HeaderSection(),
              const SizedBox(height: 40),
              TabBar(
                controller: _tabController,
                labelColor: Colors.red,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.red,
                tabs: const [
                  Tab(text: 'Phone'),
                  Tab(text: 'Email'),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _PhoneTab(
                      controller: _phoneController,
                      errorMessage: _tabController!.index == 0 ? _errorMessage : null,
                    ),
                    _EmailTab(
                      controller: _emailController,
                      errorMessage: _tabController!.index == 1 ? _errorMessage : null,
                    ),
                  ],
                ),
              ),
              _ActionButton(
                isLoading: _isLoading,
                onPressed: _tabController!.index == 0 ? _requestOtpWithPhone : _redirectToRegister,
                label: _tabController!.index == 0 ? 'SEND CODE' : 'CONTINUE',
              ),
              const _FooterText(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    print("HeaderSection build");
    return Column(
      children: [
        const SizedBox(height: 40),
        Image.asset(
          'assets/logo.png',
          height: 80,
        ),
        const SizedBox(height: 20),
        const Text(
          'DealsDray',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Login with your phone or email',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _PhoneTab extends StatelessWidget {
  final TextEditingController controller;
  final String? errorMessage;

  const _PhoneTab({required this.controller, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    print("PhoneTab build");
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Glad to see you!",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text("Please provide your phone number"),
          TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: "Phone",
              hintText: "Enter your 10-digit mobile number",
              prefixIcon: const Icon(Icons.phone, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: 10),
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class _EmailTab extends StatelessWidget {
  final TextEditingController controller;
  final String? errorMessage;

  const _EmailTab({required this.controller, this.errorMessage});

  @override
  Widget build(BuildContext context) {
    print("EmailTab build");
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: controller,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email address",
                prefixIcon: const Icon(Icons.email, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.red, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              ),
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;
  final String label;

  const _ActionButton({
    required this.isLoading,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    print("ActionButton build");
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.red.withOpacity(0.3),
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.red, Colors.redAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
                : Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterText extends StatelessWidget {
  const _FooterText();

  @override
  Widget build(BuildContext context) {
    print("FooterText build");
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Text(
        'By continuing, you agree to our\nTerms & Conditions and Privacy Policy',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }
}