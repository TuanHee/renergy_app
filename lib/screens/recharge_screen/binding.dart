import 'package:get/get.dart';
import 'controller.dart';

class RechargeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RechargeController(
    ));
  }
}

