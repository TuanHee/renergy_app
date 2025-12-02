import 'dart:async';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/charging_stats.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/components/snackbar.dart';
import 'package:renergy_app/global.dart';

const int waitingTime = 15 * 60;

class PlugInLoadingController extends GetxController {
  Order? order;
  ChargingStats? chargingStats;

  int? remainSecond;
  Timer? countdownTimer;
  Timer? apiTimer;
  bool isfetching = false;

  @override
  void onInit() async {
    super.onInit();
    order = Get.arguments as Order?;
    await pollChargingStatus();
    update();
    
  }

  void pollWaitingTime() {
    countDownWaitingTime();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countDownWaitingTime();
    });
  }

  void countDownWaitingTime() {
    DateTime? endTime = chargingStats?.order?.createdAt != null
        ? DateTime.parse(
            chargingStats!.order!.createdAt!,
          ).add(Duration(seconds: waitingTime)).toLocal()
        : null;
    remainSecond = endTime != null
        ? (endTime.millisecondsSinceEpoch -
                  DateTime.now().millisecondsSinceEpoch) ~/
              1000
        : null;
    update();
  }

  String secondToMinute(int second) {
    return '${second ~/ 60}:${second % 60 < 10 ? '0${second % 60}' : second % 60}';
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
    try {
      if (isfetching) {
        return;
      }
      isfetching = true;
      if (order?.id == null) {
        apiTimer?.cancel();
        throw ('Order id is null');
      }

      final res = await Api().get(Endpoints.chargingStats(order!.id!));

      if (res.data['status'] >= 200 && res.data['status'] < 300) {
        final data = res.data['data'];

        if (data['charging_stats'] != null) {
          chargingStats = ChargingStats.fromJson(data['charging_stats']);
          print('charging_stats: ${chargingStats?.toJson()}');

          if (countdownTimer == null) {
            pollWaitingTime();
          }
        }
      }

      if (chargingStats?.status != null) {
        await ChargingStatsStatus.page(
          chargingStats,
          chargingProcessPage.plugIn,
        );
        if (chargingStats?.status != ChargingStatsStatus.open) {
          apiTimer?.cancel();
        }
      }

      update();
    } catch (e) {
      if(Get.context == null) return;
      Snackbar.showError('Failed to fetch charging status: $e', Get.context!);
    } finally {
      isfetching = false;
    }
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
