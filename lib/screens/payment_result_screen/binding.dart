import 'package:get/get.dart';
import 'controller.dart';

class PaymentResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PaymentResultController());
  }
}