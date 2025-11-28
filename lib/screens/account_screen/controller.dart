import 'package:get/get.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/storage_service.dart';
import 'package:renergy_app/global.dart';

import '../../common/constants/storage.dart';

class AccountController extends GetxController {
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    fetchAccountDetails();
  }

  Future<void> fetchAccountDetails() async {
    isLoading = true;
    update();

    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> logout() async {
    try {
      StorageService.to.remove(storageAccessToken);
      Global.isLoginValid = false;
      Get.offAllNamed(AppRoutes.explorer);
    } catch (e) {
      print(e);
    }
  }
}
