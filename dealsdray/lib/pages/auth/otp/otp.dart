import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'otp_view_model.dart';
import '../../../routes.dart';
import 'package:sms_autofill/sms_autofill.dart';

class OtpVerificationPage extends StatefulWidget {
  final String mobileNumber;
  final String deviceId;
  final String userId;

  const OtpVerificationPage({
    super.key,
    required this.mobileNumber,
    required this.deviceId,
    required this.userId,
  });

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage>
    with CodeAutoFill {
  final TextEditingController _otpController = TextEditingController();
  bool _isListeningForCode = true;

  @override
  void initState() {
    super.initState();
    debugPrint('Starting SMS autofill listener');
    listenForCode();
    // Fallback if autofill doesn't work
    Future.delayed(Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _isListeningForCode = false;
        });
      }
    });
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 4) {
      setState(() {
        _otpController.text = code!;
        _isListeningForCode = false;
        debugPrint('Code updated: $code');
      });
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<OtpVerificationViewModel>(
          builder: (context, viewModel, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enter the OTP sent to ${widget.mobileNumber}',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    labelText: 'OTP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length != 4 || !RegExp(r'^\d{4}$').hasMatch(value)) {
                      viewModel.setErrorMessage('Please enter a valid 4-digit OTP');
                    } else {
                      viewModel.clearErrorMessage();
                    }
                  },
                ),
                const SizedBox(height: 20),
                if (_isListeningForCode && _otpController.text.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Waiting for OTP...'),
                  ),
                if (!_isListeningForCode && _otpController.text.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text('Could not detect OTP. Please enter manually.'),
                  ),
                if (viewModel.isLoading)
                  const CircularProgressIndicator(),
                if (viewModel.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      viewModel.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading || _otpController.text.length != 4
                        ? null
                        : () async {
                      final result = await viewModel.verifyOtp(
                        _otpController.text,
                        widget.deviceId,
                        widget.userId,
                      );
                      if (result == OtpVerificationResult.success) {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRoutes.dashboard,
                        );
                      } else if (result == OtpVerificationResult.newUser) {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.register,
                          arguments: {'userId': viewModel.userId},
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Verify OTP',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: viewModel.isLoading
                      ? null
                      : () async {
                    final success = await viewModel.resendOtp(
                      widget.mobileNumber,
                      widget.deviceId,
                    );
                    if (success) {
                      setState(() {
                        _isListeningForCode = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP resent successfully')),
                      );
                    }
                  },
                  child: const Text('Resend OTP'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}