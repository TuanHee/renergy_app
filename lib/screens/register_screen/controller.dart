import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/components/snackbar.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  bool isLoading = false;
  bool showPassword = false;
  bool showConfirmPassword = false;
  String? errorMessage;

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Please enter your name';
    if (value.trim().length < 2) return 'Name is too short';
    return null;
  }

  String? validatePhone(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Please enter phone number';
    final digits = v.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9) return 'Invalid phone number';
    return null;
  }

  String? validatePassword(String? value) {
    final v = value ?? '';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? validateConfirm(String? value) {
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  void toggleShowPassword() {
    showPassword = !showPassword;
    update();
  }

  void toggleShowConfirmPassword() {
    showConfirmPassword = !showConfirmPassword;
    update();
  }

  Future<void> register() async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return;
    isLoading = true;
    update();
    try {
      final payload = {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
      };
      print('register payload: $payload');
      await Api().post(Endpoints.register, data: payload);
      
      isLoading = false;
      update();
      Get.back(result: true);
      if (Get.context != null) {
        Snackbar.showSuccess('Register successful',Get.context!);
      }
      
    } catch (e) {
      isLoading = false;
      update();
      if (Get.context != null) {
        Snackbar.showError(e.toString(), Get.context!);
      }
    }
  }
}
