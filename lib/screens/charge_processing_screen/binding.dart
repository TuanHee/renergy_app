import 'package:get/get.dart';
import 'controller.dart';

class ChargeProcessingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChargeProcessingController(
    ));
  }
}

