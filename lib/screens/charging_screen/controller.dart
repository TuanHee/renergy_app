import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/charging_stats.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/services/api_service.dart';

class ChargingController extends GetxController {
  ChargingStatus status = ChargingStatus.none;
  ChargingStats? chargingStats;
  Order? order;
  String callStatus = 'start';

  @override
  void onInit() {
    super.onInit();

    initOrder();
  }

  Future<void> initOrder() async {
    if (Get.arguments != null && Get.arguments is Order) {
      status = ChargingStatus.pending;
      order = Get.arguments as Order;

      pullingData();
    }
  }

  Future<void> pullingData() async {
    callStatus = 'start';
    update();
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await getChargingStats(timer);
    });
    update();
  }

  Future<void> getChargingStats(Timer timer) async {
    try {
      final res = await Api().get('${Endpoints.chargingStats(order!.id!)}?status=$callStatus');
    
      if (res.data['status'] == 200) {
        chargingStats = ChargingStats.fromJson(res.data['data']['charging_stats']);

        if (chargingStats!.status == ChargingStatsStatus.charging) {
          inspect(chargingStats!.status);

          status = ChargingStatus.charging;
        }

        if (callStatus == 'stop') {
          status = ChargingStatus.completed;
        }

        if (callStatus == 'stop' && chargingStats!.status == ChargingStatsStatus.completed) {
          update();
          timer.cancel();
        }
      }
      update();
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to get charging stats', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white,);
      timer.cancel();
    }
  }

  Future<void> stopCharging() async {
    final res = await Api().post(Endpoints.stopCharging(order!.id!));

    if (res.data['status'] == 200) {
      Get.snackbar('Message', res.data['data']['status'], snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white,);
      callStatus = 'stop';
      update();
    } else {
      Get.snackbar('Error', 
      res.data['message'] ?? 'Failed to stop charging',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      );
    }
  }
}

