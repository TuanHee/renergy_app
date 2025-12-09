import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/charging_stats.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/components/snackbar.dart';
import 'package:renergy_app/global.dart';

const int waitingTime = 15 * 60;

class PlugInLoadingController extends GetxController with WidgetsBindingObserver {
  Order? order;
  ChargingStats? chargingStats;

  int? remainSecond;
  Timer? countdownTimer;
  Timer? apiTimer;
  bool isfetching = false;
  bool isLoading = true;
  static Timer? globalApiTimer;
  int consecutiveErrorCount = 0;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    order = Get.arguments as Order?;
    update();
  }

  @override
  void onReady() {
    super.onReady();
    pollChargingStatus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      pollChargingStatus();
    } else {
      if (PlugInLoadingController.globalApiTimer != null) {
        PlugInLoadingController.globalApiTimer!.cancel();
        PlugInLoadingController.globalApiTimer = null;
      }
    }
  }

  Future<void> pollChargingStatus() async {
    if (!Global.isLoginValid) {
      return;
    }
    if (PlugInLoadingController.globalApiTimer != null) {
      print('PlugInLoading polling already active');
      await fetchChargingStats();
    isLoading = false;
    update();
      return;
    }
    PlugInLoadingController.globalApiTimer = Timer.periodic(
      const Duration(seconds: 2),
      (timer) async {
        final c = Get.isRegistered<PlugInLoadingController>()
            ? Get.find<PlugInLoadingController>()
            : null;
        if (c == null || c.isClosed) {
          timer.cancel();
          PlugInLoadingController.globalApiTimer = null;
          return;
        }
        await c.fetchChargingStats();
      },
    );
    await fetchChargingStats();
    isLoading = false;
    update();
  }

  void pollWaitingTime() {
    countDownWaitingTime();
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      countDownWaitingTime();
    });
  }

  void countDownWaitingTime() {
    print('countDownWaitingTime in plug_in_loading_screen');
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

  Future<void> fetchChargingStats() async {
    try {
      print('fetchChargingStats in plug_in_loading_screen');
      if (isfetching) {
        return;
      }
      isfetching = true;
      if (order?.id == null) {
        PlugInLoadingController.globalApiTimer?.cancel();
        PlugInLoadingController.globalApiTimer = null;
        throw ('Order id is null');
      }

      final res = await Api().get(Endpoints.chargingStats(order!.id!));

      if (res.data['status'] >= 200 && res.data['status'] < 300) {
        final data = res.data['data'];

        if (data['charging_stats'] != null) {
          chargingStats = ChargingStats.fromJson(data['charging_stats']);

          if (countdownTimer == null) {
            pollWaitingTime();
          }
        }
        // Reset error counter on success
        consecutiveErrorCount = 0;
      }

      if (chargingStats?.status != null) {
        await ChargingStatsStatus.page(
          chargingStats,
          chargingProcessPage.plugIn,
        );
        if (chargingStats?.status != ChargingStatsStatus.open) {
          PlugInLoadingController.globalApiTimer?.cancel();
          PlugInLoadingController.globalApiTimer = null;
        }
      }

      update();
    } catch (e) {
      // Increment error count and stop timer after 5 consecutive errors
      consecutiveErrorCount++;
      if (consecutiveErrorCount >= 5) {
        if (PlugInLoadingController.globalApiTimer != null) {
          PlugInLoadingController.globalApiTimer!.cancel();
          PlugInLoadingController.globalApiTimer = null;
          print('Stopped Plug-In polling after 5 consecutive errors');
        }
      }
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
    WidgetsBinding.instance.removeObserver(this);
    countdownTimer?.cancel();
    PlugInLoadingController.globalApiTimer?.cancel();
    PlugInLoadingController.globalApiTimer = null;
    apiTimer?.cancel();
    super.onClose();
  }
}
