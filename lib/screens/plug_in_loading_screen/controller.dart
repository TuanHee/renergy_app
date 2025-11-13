import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';

class PlugInLoadingController extends GetxController {
  int chargerId;
  int powerOutput;
  String location;
  String type;
  String status = 'ready';
  int remainSecond = 10 * 60;

  @override
  void onInit() async {
    super.onInit();
    pollPlugStatus();
    countDownWaitingTime();
    update();
  }

  PlugInLoadingController({
    required this.chargerId,
    required this.powerOutput,
    required this.location,
    required this.type,
  });

  void countDownWaitingTime() {
    DateTime now = DateTime.now();
    DateTime endTime = now.add(Duration(seconds: remainSecond));

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (status == ChargingStatus.stopped.name || status == ChargingStatus.charging.name) {
        timer.cancel();
        return;
      }

      now = DateTime.now();
      remainSecond = (endTime.millisecondsSinceEpoch - now.millisecondsSinceEpoch) ~/ 1000;
      update();
    });
  }

  String secondToMinute(int second){
    return '${second ~/ 60}:${second % 60 < 10 ? '0${second % 60}' : second % 60}';
  }

  void pollPlugStatus() async {
    try {
      Timer.periodic(const Duration(seconds: 2), (timer) async {
        if (status == ChargingStatus.charging.name || status == ChargingStatus.stopped.name) {
          timer.cancel();
          return;
        }

        final res = await Api().get(Endpoints.chargingStats(chargerId));

        Get.log(
          'Polling charger status: ${res.data['data']['charging_stats']['status']}',
        );

        if (res.data['status'] == 400) {
          final data = res.data['data'];

          if (data['charging_stats']['status'] is String) {
            status = data['charging_stats']['status'];
          }
        }
      });

      Get.offAllNamed(AppRoutes.chargeProcessing);
    } catch (e, stackTrace) {
      Get.log('pollChargerStatus error: $e, stackTrace: $stackTrace');
    }
  }

  void cancelCharge() async {
    try {
      await Api().post(Endpoints.stopCharging(chargerId));
      status = ChargingStatus.stopped.name;
      Get.offAllNamed(AppRoutes.explorer);
    } catch (e, stackTrace) {
      Get.log('cancelCharging error: $e, stackTrace: $stackTrace');
    }
  }
}
