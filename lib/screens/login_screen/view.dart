import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginScreenView extends StatelessWidget {
  const LoginScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                
                // App Logo or Icon
                const Icon(
                  Icons.bolt,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 24),
                
                // Welcome Text
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                
                // Google Sign-In Button
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Implement Google Sign-In
                  },
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Apple Sign-In Button (iOS only)
                if (Platform.isIOS)
                  SignInWithAppleButton(
                    onPressed: () {
                      // TODO: Implement Apple Sign-In
                    },
                    height: 50,
                    text: 'Sign in with Apple',
                    style: SignInWithAppleButtonStyle.black,
                  ),
                
                if (Platform.isIOS) const SizedBox(height: 32),
                
                const SizedBox(height: 32),
                
                // Terms and Privacy Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    'By continuing, you agree to our Terms of Service and Privacy Policy',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}