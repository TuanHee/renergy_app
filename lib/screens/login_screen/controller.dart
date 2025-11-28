import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/constants.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/common/services/storage_service.dart';
import 'package:renergy_app/components/components.dart';
import 'package:renergy_app/global.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    isLoading = true;
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
      Global.isLoginValid = true;
      print(StorageService.to.getString(storageAccessToken));
      
      Get.offAllNamed(AppRoutes.explorer);

    } catch (e) {
      Snackbar.showError(e.toString(), Get.context!);
    } finally {
      isLoading = false;
      update();
    }

    update();
  }
}