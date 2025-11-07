import 'package:get/get.dart';
import 'package:renergy_app/screens/station_screen/controller.dart';

class StationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(StationController());
  }
}