import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../routes.dart';
import 'login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      final viewModel = Provider.of<LoginViewModel>(context, listen: false);
      viewModel.updateTab(_tabController.index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    Provider.of<LoginViewModel>(context, listen: false).disposeControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, viewModel, child) {
        // Switch to phone tab if needed
        if (viewModel.switchToPhoneTab && _tabController.index != 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _tabController.animateTo(0);
            viewModel.updateTab(0); // Sync the viewModel's currentTab
          });
        }

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Use theme background
          body: Container(
            child: SafeArea(
              child: Column(
                children: [
                  // AppBar-like header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                    child: Center(
                      child: Image.asset(
                        'assets/splash_screen.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
                  // TabBar with modern design
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      width: 230,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface.withOpacity(0.5), // Use theme surface
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: Theme.of(context).colorScheme.onPrimary,
                        unselectedLabelColor: Theme.of(context).colorScheme.onSurface,
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.secondary,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        tabs: const [
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 13.0),
                              child: Text('   Phone   '),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: Text('    Email        '),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // TabBarView
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface, // Use theme surface
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildPhoneTab(viewModel),
                          _buildEmailTab(viewModel),
                        ],
                      ),
                    ),
                  ),
                  // Loading and Error States
                  if (viewModel.isLoading)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  if (viewModel.errorMessage != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      padding: const EdgeInsets.all(10.0),
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneTab(LoginViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Glad to see you!',
            style: Theme.of(context).textTheme.titleLarge, // Use theme text style
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          Text(
            'Please provide your phone number',
            style: Theme.of(context).textTheme.labelMedium, // Use theme text style
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: viewModel.phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Mobile Number',
              hintText: 'Enter 10-digit mobile number',
              prefixIcon: Icon(Icons.phone, color: Theme.of(context).colorScheme.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            onChanged: (value) {
              if (value.length != 10 || !RegExp(r'^\d{10}$').hasMatch(value)) {
                viewModel.setErrorMessage("Please enter a valid 10-digit mobile number");
              } else {
                viewModel.clearErrorMessage();
              }
            },
          ),
          const SizedBox(height: 20),
          _buildGradientButton(
            onPressed: viewModel.isLoading
                ? null
                : () async {
              final result = await viewModel.requestOtpWithPhone();
              if (result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),
                );
                if (result.contains("successfully")) {
                  if (viewModel.userId != null && viewModel.deviceId != null) {
                    final args = {
                      'mobileNumber': viewModel.phoneController.text,
                      'deviceId': viewModel.deviceId!,
                      'userId': viewModel.userId!,
                    };
                    debugPrint('Navigating to OTP with args: $args');
                    Navigator.pushNamed(
                      context,
                      AppRoutes.otpVerification,
                      arguments: args,
                    );
                  } else {
                    viewModel.setErrorMessage('Failed to navigate: Missing userId or deviceId');
                    debugPrint('Navigation failed: userId=${viewModel.userId}, deviceId=${viewModel.deviceId}');
                  }
                }
              }
            },
            child: Text(
              'Request OTP',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailTab(LoginViewModel viewModel) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Let's Begin!",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 10),
          Text(
            "Please enter your credentials to proceed",
            style: Theme.of(context).textTheme.labelMedium,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: viewModel.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: 'Email',
              hintText: 'Enter your email address',
              prefixIcon: Icon(Icons.email, color: Theme.of(context).colorScheme.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            onChanged: (value) {
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                viewModel.setErrorMessage("Please enter a valid email address");
              } else {
                viewModel.clearErrorMessage();
              }
            },
          ),
          const SizedBox(height: 15),
          TextField(
            controller: viewModel.passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icon(Icons.lock, color: Theme.of(context).colorScheme.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            onChanged: (value) {
              if (value.length < 6) {
                viewModel.setErrorMessage("Password must be at least 6 characters");
              } else {
                viewModel.clearErrorMessage();
              }
            },
          ),
          const SizedBox(height: 15),
          TextField(
            controller: viewModel.referralController,
            decoration: InputDecoration(
              labelText: 'Referral Code (optional)',
              hintText: 'Enter referral code',
              prefixIcon: Icon(Icons.code, color: Theme.of(context).colorScheme.primary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              ),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          const SizedBox(height: 20),
          _buildGradientButton(
            onPressed: viewModel.isLoading
                ? null
                : () async {
              final result = await viewModel.registerOrLoginEmail();
              if (result != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(result)),
                );
                if (result.contains("successfully")) {
                  Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                }
              }
            },
            child: Text(
              'Login / Register',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton({required VoidCallback? onPressed, required Widget child}) {
    return AnimatedScale(
      scale: onPressed != null ? 1.0 : 0.95,
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: onPressed != null
                ? [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ]
                : [
              Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
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