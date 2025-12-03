import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/constants.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/common/services/storage_service.dart';
import 'package:renergy_app/components/components.dart';
import 'package:renergy_app/global.dart';
import 'package:renergy_app/common/services/firebase_notification.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool showPassword = false;
  String? errorMessage;

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
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

  void toggleShowPassword() {
    showPassword = !showPassword;
    update();
  }

  Future<void> login() async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return;
    isLoading = true;
    errorMessage = null;
    update();

    try {
      final res = await Api().post(
        Endpoints.login,
        data: {
          'phone': phoneController.text,
          'password': passwordController.text,
        },
      );

      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to login';
      }

      StorageService.to.setString(storageAccessToken, res.data['data']['_token']);
      await NotificationService.initializeToken();
      Global.isLoginValid = true;
      
      Get.offAllNamed(AppRoutes.explorer);

    } catch (e) {
      errorMessage = e.toString();
      if (Get.context != null) {
        Snackbar.showError(e.toString(), Get.context!);
      }
    } finally {
      isLoading = false;
      update();
    }

    update();
  }
}