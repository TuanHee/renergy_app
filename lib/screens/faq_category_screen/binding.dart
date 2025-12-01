import 'package:get/get.dart';
import 'controller.dart';

class FaqCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqCategoryController>(() => FaqCategoryController());
  }
}