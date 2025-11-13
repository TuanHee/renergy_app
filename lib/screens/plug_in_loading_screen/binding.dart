import 'package:get/get.dart';
import 'controller.dart';

class PlugInLoadingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PlugInLoadingController(
      chargerId: 1,
      powerOutput: 50,
      location: '123 Main St, Anytown, USA',
      type: 'DC',
    ));
  }
}

