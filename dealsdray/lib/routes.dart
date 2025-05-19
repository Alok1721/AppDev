import 'package:dealsdray/pages/auth/login/login.dart';
import 'package:dealsdray/pages/auth/otp/otp.dart';
import 'package:dealsdray/pages/auth/register/register.dart';
import 'package:dealsdray/pages/dashboard/dashboard.dart';
import 'package:dealsdray/pages/splash/splash.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String otpVerification = '/otp_verification';
  static const String register = '/register';
  static const String dashboard = '/dashboard';

  // Static routes without arguments
  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashPage(),
    login: (context) => const LoginPage(),
    dashboard: (context) => const DashboardPage(),
  };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == otpVerification) {
      final args = settings.arguments;
      debugPrint('onGenerateRoute: otpVerification args=$args');
      if (args is Map<String, String>) {
        final mobileNumber = args['mobileNumber'];
        final deviceId = args['deviceId'];
        final userId = args['userId'];
        if (mobileNumber != null && deviceId != null && userId != null) {
          return MaterialPageRoute(
            builder: (context) => OtpVerificationPage(
              mobileNumber: mobileNumber,
              deviceId: deviceId,
              userId: userId,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text(
                'Invalid OTP verification arguments: '
                    'mobileNumber=$mobileNumber, deviceId=$deviceId, userId=$userId',
              ),
            ),
          ),
        );
      }
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text('Invalid OTP verification argument type')),
        ),
      );
    } else if (settings.name == register) {
      final args = settings.arguments;
      debugPrint('onGenerateRoute: register args=$args');
      if (args is Map<String, String>) {
        final userId = args['userId'];
        if (userId != null) {
          return MaterialPageRoute(
            builder: (context) => RegisterPage(userId: userId),
          );
        }
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text('Invalid registration arguments: missing userId')),
          ),
        );
      }
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: Center(child: Text('Invalid registration argument type')),
        ),
      );
    }
    return null;
  }

  static Route<dynamic>? onUnknownRoute(RouteSettings settings) {
    debugPrint('onUnknownRoute: ${settings.name}');
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text('Route not found')),
      ),
    );
  }
}