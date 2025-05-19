import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'otp_view_model.dart';
import '../../../routes.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'dart:async';

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
  final List<TextEditingController> _otpControllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  bool _isListeningForCode = true;
  bool _isResendEnabled = false;
  int _resendCountdown = 2; // 2 seconds countdown
  Timer? _resendTimer;

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
    // Start the resend timer
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _isResendEnabled = false;
      _resendCountdown = 120;
    });
    _resendTimer?.cancel(); // Cancel any existing timer
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _isResendEnabled = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 4) {
      setState(() {
        for (int i = 0; i < 4; i++) {
          _otpControllers[i].text = code![i];
        }
        _isListeningForCode = false;
        debugPrint('Code updated: $code');
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _resendTimer?.cancel();
    cancel();
    super.dispose();
  }

  String _getFullOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'OTP Verification',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: Theme.of(context).appBarTheme.elevation,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<OtpVerificationViewModel>(
            builder: (context, viewModel, child) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Enter the OTP sent to ${widget.mobileNumber}',
                      style: Theme.of(context).textTheme.titleLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'A 4-digit code has been sent to your phone',
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(4, (index) {
                              return SizedBox(
                                width: 60,
                                child: TextFormField(
                                  controller: _otpControllers[index],
                                  focusNode: _focusNodes[index],
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  maxLength: 1,
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.primary,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: 24,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  onChanged: (value) {
                                    if (value.length == 1 && index < 3) {
                                      _focusNodes[index].unfocus();
                                      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                                    } else if (value.isEmpty && index > 0) {
                                      _focusNodes[index].unfocus();
                                      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                                    }
                                    final fullOtp = _getFullOtp();
                                    if (fullOtp.length != 4 || !RegExp(r'^\d{4}$').hasMatch(fullOtp)) {
                                      viewModel.setErrorMessage('Please enter a valid 4-digit OTP');
                                    } else {
                                      viewModel.clearErrorMessage();
                                    }
                                  },
                                ),
                              );
                            }),
                          ),
                          const SizedBox(height: 20),
                          if (_isListeningForCode && _getFullOtp().isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Waiting for OTP...',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          if (!_isListeningForCode && _getFullOtp().isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Could not detect OTP. Please enter manually.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          if (viewModel.isLoading)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          if (viewModel.errorMessage != null)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Theme.of(context).colorScheme.error),
                              ),
                              child: Text(
                                viewModel.errorMessage!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          const SizedBox(height: 10),
                          _buildGradientButton(
                            onPressed: viewModel.isLoading || _getFullOtp().length != 4
                                ? null
                                : () async {
                              final result = await viewModel.verifyOtp(
                                _getFullOtp(),
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
                            child: Text(
                              'Verify OTP',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: viewModel.isLoading || !_isResendEnabled
                                ? null
                                : () async {
                              final success = await viewModel.resendOtp(
                                widget.mobileNumber,
                                widget.deviceId,
                              );
                              if (success) {
                                setState(() {
                                  _isListeningForCode = true;
                                  for (var controller in _otpControllers) {
                                    controller.clear();
                                  }
                                });
                                _startResendTimer(); // Restart the timer after resend
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('OTP resent successfully')),
                                );
                              }
                            },
                            child: Text(
                              _isResendEnabled ? 'Resend OTP' : 'Resend in ${_resendCountdown}s',
                              style: TextStyle(
                                color: _isResendEnabled
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGradientButton({required VoidCallback? onPressed, required Widget child}) {
    return AnimatedScale(
      scale: onPressed != null ? 1.0 : 0.95,
      duration: const Duration(milliseconds: 200),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}