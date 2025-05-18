import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_view_model.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SplashViewModel>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.checkDeviceRegistration();
    });

    if (!viewModel.isLoading && viewModel.errorMessage == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/login');
      });
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/splash_screen.png',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            if (viewModel.isLoading)
              const CircularProgressIndicator(),
            if (viewModel.errorMessage != null) ...[
              Text(viewModel.errorMessage!),
              ElevatedButton(
                onPressed: () => viewModel.checkDeviceRegistration(),
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
