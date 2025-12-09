import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/models/car.dart';
import 'package:renergy_app/common/models/credit_card.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/models/station.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/components/components.dart';

class StationController extends GetxController {
  bool isLoading = true;
  bool isRefreshing = false;
  late Station station;
  int? selectedBay;
  int? selectedCar;
  late int stationId;
  bool unlockable = false;
  List<Car> vehicles = [];
  CreditCard? selectedCard;

  @override
  void onInit() async {
    super.onInit();

    stationId = Get.arguments;
    isLoading = true;
  await Future.wait([
      initStation(),
      initCar(),
      initCard(),
    ]);
    
    isLoading = false;
    
    update();
  }

  Future<void> initStation() async {
    isRefreshing = true;
    update();
    try {
      final res = await Api().get(Endpoints.station(stationId));
      
      if (res.data['status'] == 200) {
        unlockable = res.data['data']['unlockable'];
        print('res.data: ${res.data}');
        print('unlockable: $unlockable');
        station = Station.fromJson(res.data['data']['station']);
      }
    } catch (e) {
      print(e);
    } finally {
      isRefreshing = false;
      update();
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
      if(vehicles.isNotEmpty){
      selectCar(vehicles.firstWhere((car) => car.isDefault == true, orElse: () => vehicles.first).id);
    }
      update();
    } catch (e) {
      print(e);
    }
  }

  Future<void> initCard() async {
    try {
      final res = await Api().get(Endpoints.paymentMethods);
      List<CreditCard> cards = [];
      print('res: $res');
      
      if (res.data['status'] == 200) {
        cards = (res.data['data']['cards'] as List)
            .map((e) => CreditCard.fromJson(e))
            .toList();
      }
      if(cards.isNotEmpty){
      selectedCard = (cards.firstWhere((card) => card.isDefault == true, orElse: () => cards.first));
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
      // if(!unlockable){
      //   Snackbar.showError('This station is not unlockable', Get.context!);
      //   return;
      // }

      if(selectedBay == null){
        Snackbar.showError('Please select a bay.', Get.context!);
        return;
      }

      if(selectedCar == null){
        Snackbar.showError('Please select a car.', Get.context!);
        return;
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
      Snackbar.showError(e.toString(), Get.context!);
    }
  }
}