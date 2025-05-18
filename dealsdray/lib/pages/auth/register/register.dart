import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'register_view_model.dart';

class RegisterPage extends StatelessWidget {
  final String userId;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  RegisterPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _referralController,
              decoration: const InputDecoration(
                labelText: 'Referral Code',
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
                final success = await viewModel.registerUser(
                  _emailController.text,
                  _passwordController.text,
                  _referralController.text,
                  userId,
                );
                if (success) {
                  Navigator.pushNamed(context, '/dashboard');
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}