import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'otp_view_model.dart';

class OtpVerificationPage extends StatelessWidget {
  final String mobileNumber;
  final String deviceId;
  final TextEditingController _otpController = TextEditingController();

  OtpVerificationPage({super.key, required this.mobileNumber, required this.deviceId});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<OtpVerificationViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Enter the OTP sent to $mobileNumber'),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'OTP',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (viewModel.isLoading)
              const CircularProgressIndicator(),
            if (viewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  viewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ElevatedButton(
              onPressed: viewModel.isLoading
                  ? null
                  : () async {
                final success = await viewModel.verifyOtp(
                  _otpController.text,
                  deviceId,
                  mobileNumber,
                );
                if (success) {
                  Navigator.pushNamed(
                    context,
                    '/dashboard',
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    '/register',
                    arguments: {
                      'userId': viewModel.userId,
                    },
                  );
                }
              },
              child: const Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}