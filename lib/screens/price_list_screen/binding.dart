import 'package:get/get.dart';
import 'controller.dart';

class PriceListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PriceListController>(() => PriceListController());
  }
}