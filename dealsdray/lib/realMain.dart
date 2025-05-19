import 'package:dealsdray/pages/auth/login/login_view_model.dart';
import 'package:dealsdray/pages/auth/otp/otp_view_model.dart';
import 'package:dealsdray/pages/dashboard/dashboard_repo.dart';
import 'package:dealsdray/pages/dashboard/dashboard_view_model.dart';
import 'package:dealsdray/pages/user/user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dealsdray/pages/splash/splash.dart';
import 'package:dealsdray/pages/splash/splash_view_model.dart';
import 'routes.dart';

class AppState with ChangeNotifier {
  // App-wide state
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => SplashViewModel()),
        ChangeNotifierProvider(create: (_)=>LoginViewModel()),
        ChangeNotifierProvider(create: (_) => OtpVerificationViewModel()),
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(dashboardRepo: DashboardRepo()),
        ),
      ],
      child: DealDray(),
    ),
  );
}

class DealDray extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DealsDray',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: AppRoutes.routes,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      onUnknownRoute: AppRoutes.onUnknownRoute,
    );
  }
}
