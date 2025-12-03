import 'dart:async';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/charging_stats.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/components/snackbar.dart';
import 'package:renergy_app/global.dart';

class ChargeProcessingController extends GetxController {
  static Timer? globalApiTimer;
  bool isLoading = true;
  String status = ChargingStatsStatus.charging.name;
  Order? order;
  ChargingStats? chargingStats;
  bool isfetching = false;

  @override
  void onInit() async {
    super.onInit();
    order = Get.arguments as Order?;
    update();
  }

  @override
  void onReady() {
    super.onReady();
    pollChargingStatus();
  }

  void pollChargingStatus() async {
    if (order?.id == null || !Global.isLoginValid) {
      return;
    }
    // If a global timer is already running, just fetch once and return
    if (ChargeProcessingController.globalApiTimer != null) {
      print('ChargeProcessing polling already active');
      await fetchChargingStatus();
      return;
    }
    ChargeProcessingController.globalApiTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        final c = Get.isRegistered<ChargeProcessingController>()
            ? Get.find<ChargeProcessingController>()
            : null;
        if (c == null || c.isClosed) {
          timer.cancel();
          ChargeProcessingController.globalApiTimer = null;
          return;
        }
        await c.fetchChargingStatus();
      },
    );
    await fetchChargingStatus();
  }

  Future<void> fetchChargingStatus() async {
    try {
      print('fetchChargingStatus in charge_processing_screen');

      final res = await Api().get(Endpoints.chargingStats(order!.id!));

      if (res.data['status'] >= 200 && res.data['status'] < 300) {
        final data = res.data['data'];

        if (data['charging_stats']['status'] is String) {
          status = data['charging_stats']['status'];
        }

        chargingStats = ChargingStats.fromJson(
          res.data['data']['charging_stats'],
        );

        ChargingStatsStatus.page(
          chargingStats!,
          chargingProcessPage.chargingProcessing,
        );
        update();
      }
    } catch (e) {
      if (Get.context == null) {
        return;
      }
      Snackbar.showError(e.toString(), Get.context!);
    }
  }

  Future<void> stopCharging() async {
    if (order?.id == null) {
      return;
    }
    final res = await Api().post(Endpoints.stopCharging(order!.id!));

    if (res.data['status'] != 200) {
      throw 'Stop Charging Error: ${res.data['status']}';
    }
  }

  @override
  void onClose() {
    ChargeProcessingController.globalApiTimer?.cancel();
      ChargeProcessingController.globalApiTimer = null;
    super.onClose();
  }
}
