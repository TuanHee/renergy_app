import 'dart:async';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/charging_stats.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/components/snackbar.dart';
import 'package:renergy_app/global.dart';

class ChargeProcessingController extends GetxController {
  bool isLoading = true;
  String status = ChargingStatsStatus.charging.name;
  Order? order;
  ChargingStats? chargingStats;
  Timer? apiTimer;
  bool isfetching = false;

  @override
  void onInit() async {
    super.onInit();
    order = Get.arguments as Order?;
    update();
  }

  void pollChargingStatus() async {
    apiTimer?.cancel();
    if (order?.id == null || !Global.isLoginValid) {
      return;
    }
    await fetchChargingStatus();
    apiTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      await fetchChargingStatus();
    });
  }

  Future<void> fetchChargingStatus()async{
    try{
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
        if(Get.context == null){
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
    apiTimer?.cancel();
    super.onClose();
  }
}
