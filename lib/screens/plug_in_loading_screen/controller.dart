import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';

const int waitingTime = 15 * 60;

class PlugInLoadingController extends GetxController {
  Order? order;
  String status = 'ready';
  DateTime startTime = DateTime.now();

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
    DateTime endTime = startTime.add(Duration(seconds: waitingTime));

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (status == ChargingStatsStatus.finishing.name ||
          status == ChargingStatsStatus.charging.name) {
        timer.cancel();
        return;
      }

      int remainSecond = endTime.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch ~/ 1000;
      update();
    });
  }

  String secondToMinute(int second) {
    return '${second ~/ 60}:${second % 60 < 10 ? '0${second % 60}' : second % 60}';
  }

  Future<void> pollPlugStatus(BuildContext context) async {
    apiTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        if (status == ChargingStatsStatus.charging.value) {
          countdownTimer?.cancel();
          timer.cancel();
          Get.offAllNamed(AppRoutes.chargeProcessing, arguments: order);
          return;
        }

        if (status == ChargingStatsStatus.cancelled.name) {
          countdownTimer?.cancel();
          timer.cancel();
          Get.offAllNamed(AppRoutes.charging, arguments: order);
          return;
        }

        final res = await Api().get(Endpoints.chargingStats(order!.id!));

        if (res.data['status'] >= 200 && res.data['status'] < 300) {
          final data = res.data['data'];

          if (data['charging_stats']['status'] is String) {
            status = data['charging_stats']['status'];
            startTime = DateTime.parse(data['charging_stats']['started_at']);
          }
        }
        update();
      } catch (e, stackTrace) {
        print('pollPlugStatus error: $e, $stackTrace');
      }
    });
  }

  Future<void> cancelPending() async {
    try {
      final res = await Api().delete(Endpoints.order(order!.id!));
      countdownTimer?.cancel();
        apiTimer?.cancel();

      if (res.data['status'] != 200) {
        throw'Failed to cancel order: Try again later';
      }
    } catch (e, stackTrace) {
      rethrow;
    }
  }
}
