import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/constants.dart';
import 'package:renergy_app/common/models/charging_stats.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/components/snackbar.dart';
import 'package:renergy_app/global.dart';

import '../plug_in_loading_screen/controller.dart';

class RechargeController extends GetxController {
  bool isLoading = true;

  Timer? apiTimer;
  Timer? countdownTimer;
  int? remainSecond;
  ChargingStats? chargingStats;
  bool canRecharge = true;
  bool isfetching = false;

  Order? order;

  @override
  void onInit() async {
    super.onInit();
    final args = Get.arguments;
    if (args is Order) {
      order = args;
    } else if (args is Map) {
      final rawOrder = args['order'];
      if (rawOrder is Order) {
        order = rawOrder;
      } else if (rawOrder is Map<String, dynamic>) {
        order = Order.fromJson(rawOrder);
      }
      canRecharge = args['canRecharge'] as bool? ?? true;
    }

    await pollChargingStatus();
  }

  String secondToMinute(int second) {
    return '${second ~/ 60}:${second % 60 < 10 ? '0${second % 60}' : second % 60}';
  }

  void pollWaitingTime() {
    countDownWaitingTime();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countDownWaitingTime();
    });
  }

  void countDownWaitingTime() {
    print('countDownWaitingTime in recharge_screen');
    DateTime? endTime =
        DateTime.tryParse(
          chargingStats?.stopAt ?? '',
        )?.toLocal().add(const Duration(seconds: waitingTime)) ??
        null;
    remainSecond = endTime != null
        ? (endTime.millisecondsSinceEpoch -
                  DateTime.now().millisecondsSinceEpoch) ~/
              1000
        : null;
    update();
  }

  Future<void> pollChargingStatus() async {
    apiTimer?.cancel();
    if (!Global.isLoginValid) {
      return;
    }
    await fetchChargingStats();
    apiTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      await fetchChargingStats();
    });
  }

  Future<void> fetchChargingStats() async {
    if (isClosed) {
      return;
    }
    print('fetchChargingStats in recharge_screen');
    try {
      if (isfetching) {
        return;
      }
      isfetching = true;
      final res = await Api().get(Endpoints.chargingStats(order!.id!));

      if (res.data['status'] >= 200 && res.data['status'] < 300) {
        final data = res.data['data'];

        if (data['charging_stats']['status'] is String) {
          chargingStats = ChargingStats.fromJson(data['charging_stats']);
          if (countdownTimer == null) {
            pollWaitingTime();
          }
        }
      }
      if (isClosed) {
        return;
      }
      ChargingStatsStatus.page(chargingStats!, chargingProcessPage.recharge);
      update();
    } catch (e) {
      if (Get.context == null) {
        return;
      }
      Snackbar.showError(e.toString(), Get.context!);
    } finally {
      isfetching = false;
    }
  }

  Future<void> restart() async {
    if (order?.id == null) {
      return;
    }
    final res = await Api().post(Endpoints.restart(order!.id!));

    if (res.data['status'] != 200) {
      throw 'Stop Charging Error: ${res.data['status']}';
    }
  }

  @override
  void onClose() {
    countdownTimer?.cancel();
    apiTimer?.cancel();
    super.onClose();
  }
}
