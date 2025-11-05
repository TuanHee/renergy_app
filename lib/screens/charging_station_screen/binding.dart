import 'package:get/get.dart';
import 'package:renergy_app/screens/charging_station_screen/charging_station_screen.dart';

class ChargingStationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ChargingStationController());
  }
}