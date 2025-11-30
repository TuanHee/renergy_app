import 'dart:async';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/charging_stats.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/global.dart';

class ChargeProcessingController extends GetxController {
  bool isLoading = true;
  String status = ChargingStatsStatus.charging.name;
  Order? order;
  ChargingStats? chargingStats;
  Timer? pollingTimer;
  bool isfetching = false;

  @override
  void onInit() async {
    super.onInit();
    order = Get.arguments as Order?;
    update();
  }

  void pollChargingStatus() async {
    if (order?.id == null || !Global.isLoginValid) {
      return;
    }
    pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        if (isfetching) {
          return;
        }
        isfetching = true;
        final res = await Api().get(Endpoints.chargingStats(order!.id!));

        if (res.data['status'] >= 200 && res.data['status'] < 300) {
          final data = res.data['data'];

          if (data['charging_stats']['status'] is String) {
            status = data['charging_stats']['status'];
          }

          chargingStats = ChargingStats.fromJson(
            res.data['data']['charging_stats'],
          );

          ChargingStatsStatus.page(chargingStats!, chargingProcessPage.chargingProcessing);
          update();
        }

        if (chargingStats?.status == ChargingStatsStatus.completed) {
          timer.cancel();
          Get.toNamed(
            AppRoutes.recharge,
            arguments: Get.find<ChargeProcessingController>().order,
          );
        }
      } catch (e) {
        print('Polling Error: $e');
      } finally {
        isfetching = false;
      }
    });
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
    pollingTimer?.cancel();
    super.onClose();
  }
}
