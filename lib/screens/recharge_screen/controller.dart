import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/constants.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';

import '../plug_in_loading_screen/controller.dart';

class RechargeController extends GetxController {
  bool isLoading = true;

  Timer? apiTimer;
  Timer? countdownTimer;
  int remainSecond = 15 * 60;
  DateTime startTime = DateTime.now();

  String status = ParkingStatus.unavailable.value;
  Order? order;

  @override
  void onInit() async {
    super.onInit();
    order = Get.arguments as Order?;
    countDownWaitingTime();

    // cards = [
    //   CreditCard(
    //     cardNumber: '**** **** **** 9010',
    //     cardHolder: 'John Doe',
    //     expiryDate: '12/25',
    //     cvv: '123',
    //     cardType: CardType.visa,
    //   ),
    // ];
  }

  String secondToMinute(int second) {
    return '${second ~/ 60}:${second % 60 < 10 ? '0${second % 60}' : second % 60}';
  }

  void recharge() {
    Get.offAllNamed(AppRoutes.plugInLoading, arguments: order);
  }

  void countDownWaitingTime() {
    DateTime endTime = startTime.add(Duration(seconds: waitingTime));

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (status == ChargingStatsStatus.finishing.name ||
          status == ChargingStatsStatus.charging.name) {
        timer.cancel();
        return;
      }

      remainSecond =
          (endTime.millisecondsSinceEpoch -
          DateTime.now().millisecondsSinceEpoch) ~/ 1000;
      update();
    });
  }

  Future<void> pollChargingStatus(BuildContext context) async {
    apiTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        if (status == ChargingStatsStatus.restarting.value) {
          countdownTimer?.cancel();
          timer.cancel();
          Get.offAllNamed(AppRoutes.plugInLoading, arguments: order);
        }

        if (status == ChargingStatsStatus.open.value) {
          countdownTimer?.cancel();
          timer.cancel();
          Get.offAllNamed(AppRoutes.chargeProcessing, arguments: order);
          return;
        }
        // if (status == ChargingStatsStatus.charging.value) {
        //   countdownTimer?.cancel();
        //   timer.cancel();
        //   Get.offAllNamed(AppRoutes.chargeProcessing, arguments: order);
        //   return;
        // }

        // if (status == ChargingStatsStatus.cancelled.name) {
        //   countdownTimer?.cancel();
        //   timer.cancel();
        //   Get.offAllNamed(AppRoutes.charging, arguments: order);
        //   return;
        // }

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
        timer.cancel();
        print('pollChargingStatus error: $e, $stackTrace');
      }
    });
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
}
