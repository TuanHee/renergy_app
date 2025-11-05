import 'package:get/get.dart';

class ChargingStationController extends GetxController {
  String? stationImageUrl;
  String? stationName;
  String? address;
  String? selectedBay;

  @override
  void onInit() {
    super.onInit();
    stationImageUrl = 'https://picsum.photos/500/300';
    stationName = 'Crest Austin Sales Gallery';
    address = 'Inside Crest@Austin Sales Gallery Car Park, Persiaran Jaya Putra, Taman Jaya Putra, Johor Bahru, Johor, Malaysia, 81100, Johor Bahru, Johor, Malaysia';
  }

  void selectBay(String bayNumber) {
    selectedBay = bayNumber;
    update();
  }
}