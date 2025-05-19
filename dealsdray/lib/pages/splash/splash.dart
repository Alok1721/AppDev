import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../routes.dart';
import 'splash_view_model.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkDeviceRegistration();
  }

  Future<void> _checkDeviceRegistration() async {
    final viewModel = Provider.of<SplashViewModel>(context, listen: false);
    await Future.wait([
      viewModel.checkDeviceRegistration(),
      Future.delayed(const Duration(seconds: 5)),
    ]);
    if (!viewModel.isLoading && viewModel.errorMessage == null) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    } else {
      // Log error for debugging
      debugPrint('Device registration failed: ${viewModel.errorMessage}');
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("SplashPage build");
    return Consumer<SplashViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/splash_screen2.png',
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 20),
                if (viewModel.isLoading)
                  const CircularProgressIndicator(),
                if (viewModel.errorMessage != null) ...[
                  Text(
                    viewModel.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _checkDeviceRegistration,
                    child: const Text('Retry'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}