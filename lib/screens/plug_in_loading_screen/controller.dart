import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/charging_stats.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/global.dart';

const int waitingTime = 15 * 60;

class PlugInLoadingController extends GetxController {
  Order? order;
  ChargingStats? chargingStats;

  int remainSecond = waitingTime;
  Timer? countdownTimer;
  Timer? apiTimer;

  @override
  void onInit() async {
    super.onInit();
    order = Get.arguments as Order?;

    countDownWaitingTime();
    update();
  }

  void countDownWaitingTime() {
    DateTime endTime = chargingStats?.startAt == null
        ? DateTime.now().add(Duration(seconds: waitingTime))
        : DateTime.tryParse(
            chargingStats!.startAt!,
          )!.add(Duration(seconds: waitingTime));

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {

      remainSecond =
          (endTime.millisecondsSinceEpoch -
              DateTime.now().millisecondsSinceEpoch) ~/
          1000;
      update();
    });
  }

  String secondToMinute(int second) {
    return '${second ~/ 60}:${second % 60 < 10 ? '0${second % 60}' : second % 60}';
  }

  Future<void> pollChargingStatus(BuildContext context) async {
    if(!Global.isLoginValid){
      return;
    }
    apiTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        if (order?.id == null) {
          timer.cancel();
          throw ('Order id is null');
        }

        final res = await Api().get(Endpoints.chargingStats(order!.id!));

        if (res.data['status'] >= 200 && res.data['status'] < 300) {
          final data = res.data['data'];
          print('charging_stats: ${data['charging_stats']}');

          if (data['charging_stats'] != null) {
            chargingStats = ChargingStats.fromJson(data['charging_stats']);
          }
        }

        if (chargingStats?.status != null) {
          ChargingStatsStatus.page(chargingStats, chargingProcessPage.plugIn);
        }
        
        update();
      } catch (e, stackTrace) {
        print('pollChargingStatus error: $e, $stackTrace');
      }
    });
  }

  Future<void> cancelPending() async {
    try {
      final res = await Api().delete(Endpoints.order(order!.id!));

      if (res.data['status'] != 200) {
        throw 'Failed to cancel order: Try again later';
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  void onClose() {
    countdownTimer?.cancel();
    apiTimer?.cancel();
    super.onClose();
  }
}
