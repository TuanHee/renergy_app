import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/models/station.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';

class StationController extends GetxController {
  bool isLoading = true;
  String? stationImageUrl;
  late Station station;
  int? selectedBay;
  int? selectedCar;
  late int stationId;

  @override
  void onInit() async {
    super.onInit();

    stationId = Get.arguments;
  
    stationImageUrl = 'https://picsum.photos/500/300';
    isLoading = true;
    await initStation();
    isLoading = false;
    update();
  }

  Future<void> initStation() async {
    try {
      final res = await Api().get(Endpoints.station(stationId));
      
      if (res.data['status'] == 200) {
        station = Station.fromJson(res.data['data']['station']);
      }
    } catch (e) {
      print(e);
    }
  }

  void selectBay(int bayId) {
    selectedBay = bayId;
    update();
  }

  void selectCar(int carId) {
    selectedCar = carId;
    update();
  }

  Future<void> unlockBay() async {
    try {
      final res = await Api().post(
        Endpoints.order, 
        data:{
          'bay_id': selectedBay!,
          'vehicle_id': selectedCar!,
        }
      );

      if (res.data['status'] == 200) {
        Order order = Order.fromJson(res.data['data']['order']);
        Get.offAllNamed(AppRoutes.charging, arguments: order);
      } else {
        Get.snackbar(
          'Error',
          res.data['message'] ?? 'Failed to unlock bay',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      log('Error in unlockBay: $e');
    }
  }
}