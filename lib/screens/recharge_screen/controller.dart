import 'dart:async';

import 'package:get/get.dart';
import 'package:renergy_app/common/constants/constants.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';


class RechargeController extends GetxController {
  bool isLoading = true;

  Timer? apiTimer;
  Timer? remainSecondTimer;
  int remainSecond = 15 * 60;

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
    Get.offAllNamed(AppRoutes.plugInLoading,  arguments: order);
  }

  void countDownWaitingTime() {
    DateTime now = DateTime.now();
    DateTime endTime = now.add(Duration(seconds: remainSecond));

    remainSecondTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (status == ChargingStatus.stopped.name || status == ChargingStatus.charging.name) {
        timer.cancel();
        return;
      }

      now = DateTime.now();
      remainSecond = (endTime.millisecondsSinceEpoch - now.millisecondsSinceEpoch) ~/ 1000;
      update();
    });
  }

  void pollParkingStatus() async {
      apiTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        if (status == ParkingStatus.unavailable.value) {
          remainSecondTimer?.cancel();
          timer.cancel();
          Get.offAllNamed(AppRoutes.charging, arguments: order);
          return;
        }

        // final res = await Api().get(Endpoints.chargingStats(order!.id!));

        // if (res.data['status'] >= 200 && res.data['status'] < 300) {
        //   final data = res.data['data'];

        //   if (data['charging_stats']['status'] is String) {
        //     status = data['charging_stats']['status'];
        //   }
        // }

      });
  }

  Future<void> restart() async {
    if(order?.id == null){
      return;
    }
    final res = await Api().post(Endpoints.restart(order!.id!));
    
    if (res.data['status'] != 200) {
      throw 'Stop Charging Error: ${res.data['status']}';
    }
  }
}

