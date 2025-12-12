import 'package:get/get.dart';
import 'controller.dart';

class PhoneVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PhoneVerificationController());
  }
}