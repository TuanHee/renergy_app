import 'package:get/get.dart';
import 'controller.dart';

class EditCarBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(EditCarController());
  }
}