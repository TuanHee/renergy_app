import 'package:get/get.dart';
import 'controller.dart';

class CarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CarController(
    ));
  }
}

