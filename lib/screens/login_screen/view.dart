import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/screens/login_screen/login_screen.dart';

class LoginScreenView extends StatelessWidget {
  const LoginScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(centerTitle: true, title: const Text('Login')),
          body: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      const Icon(Icons.bolt, size: 64, color: Colors.red),
                      const SizedBox(height: 12),
                      const Text(
                        'Welcome',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Sign in to continue',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Phone Number',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.phoneController,
                        validator: controller.validatePhone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          hintText: 'e.g. 0123456789',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: controller.passwordController,
                        validator: controller.validatePassword,
                        obscureText: !controller.showPassword,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: 'Enter password',
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: controller.toggleShowPassword,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (controller.errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade700,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.errorMessage!,
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: controller.isLoading
                              ? null
                              : controller.login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: controller.isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Login'),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Divider
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Login or Sign up',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          onPressed: () => Get.toNamed(AppRoutes.register),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Register Now',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),

                      // Google Sign-In Button
                      // ElevatedButton.icon(
                      //   onPressed: () {
                      //     // TODO: Implement Google Sign-In
                      //   },
                      //   icon: const Icon(Icons.login, color: Colors.white),
                      //   label: const Text(
                      //     'Sign in with Google',
                      //     style: TextStyle(fontSize: 16),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.red.shade600,
                      //     foregroundColor: Colors.white,
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 32,
                      //       vertical: 16,
                      //     ),
                      //     minimumSize: const Size(double.infinity, 50),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //   ),
                      // ),

                      // const SizedBox(height: 16),

                      // // Apple Sign-In Button (iOS only)
                      // if (Platform.isIOS)
                      //   SignInWithAppleButton(
                      //     onPressed: () {
                      //       // TODO: Implement Apple Sign-In
                      //     },
                      //     height: 50,
                      //     text: 'Sign in with Apple',
                      //     style: SignInWithAppleButtonStyle.black,
                      //   ),

                      // if (Platform.isIOS) const SizedBox(height: 32),
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
          ),
        );
      },
    );
  }
}
