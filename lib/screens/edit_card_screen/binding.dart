import 'package:get/get.dart';
import 'controller.dart';

class EditCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditCardController>(() => EditCardController());
  }
}