import 'dart:developer';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/models/car.dart';
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
  bool unlockable = false;
  List<Car> vehicles = [];

  @override
  void onInit() async {
    super.onInit();

    stationId = Get.arguments;
  
    stationImageUrl = 'https://picsum.photos/500/300';
    isLoading = true;
    await Future.wait([
      initStation(),
      initCar(),
    ]);
    
    isLoading = false;
    if(vehicles.isNotEmpty){
      selectCar(vehicles.firstWhere((car) => car.isDefault == true, orElse: () => vehicles.first).id);
    }
    update();
  }

  Future<void> initStation() async {
    try {
      final res = await Api().get(Endpoints.station(stationId));
      
      if (res.data['status'] == 200) {
        unlockable = res.data['data']['unlockable'];
        station = Station.fromJson(res.data['data']['station']);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> initCar() async {
    try {
      final res = await Api().get(Endpoints.vehicles);
      
      if (res.data['status'] == 200) {
        vehicles = (res.data['data']['vehicles'] as List)
            .map((e) => Car.fromJson(e))
            .toList();
      }
      update();
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
      if(unlockable){
        false;
      }
      
      final res = await Api().post(
        Endpoints.orders, 
        data:{
          'bay_id': selectedBay!,
          'vehicle_id': selectedCar!,
        }
      );

      if (res.data['status'] == 200) {
        Order order = Order.fromJson(res.data['data']['order']);
        Get.offAllNamed(AppRoutes.plugInLoading, arguments: order);
      } else {
        throw Exception(res.data['message'] ?? 'Failed to unlock bay');
      }
    } catch (e) {
      print('Error in unlockBay: $e');
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