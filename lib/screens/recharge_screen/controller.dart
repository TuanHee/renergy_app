import 'dart:async';

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
  static Timer? globalApiTimer;

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

    update();
  }

  @override
  void onReady() {
    super.onReady();
    pollChargingStatus();
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
    if (!Global.isLoginValid) {
      return;
    }
    if (RechargeController.globalApiTimer != null) {
      print('Recharge polling already active');
      await fetchChargingStats();
      return;
    }
    RechargeController.globalApiTimer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) async {
        final c = Get.isRegistered<RechargeController>()
            ? Get.find<RechargeController>()
            : null;
        if (c == null || c.isClosed) {
          timer.cancel();
          RechargeController.globalApiTimer = null;
          return;
        }
        await c.fetchChargingStats();
      },
    );
    await fetchChargingStats();
  }

  @override
  void onClose() {
    countdownTimer?.cancel();
    RechargeController.globalApiTimer?.cancel();
    RechargeController.globalApiTimer = null;
    apiTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchChargingStats() async {
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
      ChargingStatsStatus.page(chargingStats!, chargingProcessPage.recharge);
      update();
    } catch (e) {
      if (Get.context == null) {
        return;
      }
      // Snackbar.showError(e.toString(), Get.context!);
    } finally {
      isfetching = false;
    }
  }
  Future<void> recharge() async {
    if (order?.id == null) {
      return;
    }
    final res = await Api().post(Endpoints.restart(order!.id!));

    if (res.data['status'] != 200) {
      throw 'Stop Charging Error: ${res.data['status']}';
    }
  }
}
