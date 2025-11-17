import 'package:get/get.dart';
import 'controller.dart';

class AddCarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddCarController());
  }
}