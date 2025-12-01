import 'package:get/get.dart';
import 'controller.dart';

class GetHelpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetHelpController>(() => GetHelpController());
  }
}