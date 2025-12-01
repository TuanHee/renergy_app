import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/constants.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/common/services/storage_service.dart';

class Global {
  static bool isLoginValid = false;

  static Future init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Get.putAsync<StorageService>(() => StorageService().init());
    await checkLoginStatus();
  }

  static Future<void> checkLoginStatus() async {
    String? accessToken = StorageService.to.getString(storageAccessToken);
    if (accessToken != null && accessToken != '') {
      try {
        final res = await Api().get(Endpoints.profile);
        
        isLoginValid = res.data['status'] == 200;
      } catch (e) {
        print('error: $e');
      }
    } else {
      isLoginValid = false;
    }
  }
}