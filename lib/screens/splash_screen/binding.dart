import 'package:get/get.dart';
import 'package:renergy_app/screens/splash_screen/splash_screen.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashScreenController());
  }
}

