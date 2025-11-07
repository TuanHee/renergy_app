import 'package:get/get.dart';
import 'package:renergy_app/screens/charging_screen/charging_screen.dart';

class ChargingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChargingController());
  }
}

