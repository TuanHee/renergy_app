import 'package:get/get.dart';
import 'controller.dart';

class CardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CardController(
    ));
  }
}

