import 'dart:async';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/charging_stats.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/components/components.dart';

class ChargeProcessingController extends GetxController {
  bool isLoading = true;
  String? errorMessage;
  String status = ChargingStatus.charging.name;
  Order? order;
  ChargingStats? chargingStats;

  @override
  void onInit() async {
    super.onInit();
    order = Get.arguments as Order;
    pollChargingStatus();
    update();
  }

  void pollChargingStatus() async {
    try {
      while (status == ChargingStatus.charging.name) {
        await Future.delayed(const Duration(seconds: 2));

        final res = await Api().get(Endpoints.chargingStats(order!.id!));

        if (res.data['status'] >= 200 && res.data['status'] < 300) {
          final data = res.data['data'];

          if (data['charging_stats']['status'] is String) {
            status = data['charging_stats']['status'];
          }

          chargingStats = ChargingStats.fromJson(
            res.data['data']['charging_stats'],
          );
          update();
        }
      }
    } catch (e, stackTrace) {
      errorMessage = 'Error: $e, stackTrace: $stackTrace';
      update();
    }
  }

  Future<void> stopCharging() async {
    final res = await Api().post(Endpoints.stopCharging(order!.id!));
    
    if (res.data['status'] != 200) {
      throw 'Stop Charging Error: ${res.data['status']}';
    }
  }
}
