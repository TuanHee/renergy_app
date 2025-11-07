import 'package:get/get.dart';
import 'package:renergy_app/screens/explorer_screen/controller.dart';

class ExplorerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ExplorerController());
  }
}

