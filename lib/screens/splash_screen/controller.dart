import 'dart:async';
import 'package:get/get.dart';
import '../../common/routes/app_routes.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToHome();
  }

  void _navigateToHome() {
    Timer(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.explorer);
    });
  }
}

