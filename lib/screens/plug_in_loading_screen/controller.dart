import 'dart:async';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';

class PlugInLoadingController extends GetxController {
  Order? order;
  String status = 'ready';
  int remainSecond = 15 * 60;
  String errorMessage = '';

  Timer? remainSecondTimer;
  Timer? apiTimer;

  @override
  void onInit() async {
    super.onInit();
    order = Get.arguments as Order;

    countDownWaitingTime();
    update();
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

  String secondToMinute(int second){
    return '${second ~/ 60}:${second % 60 < 10 ? '0${second % 60}' : second % 60}';
  }

  void pollPlugStatus() async {
    try {
      apiTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        if (status == ChargingStatus.charging.value) {
          remainSecondTimer?.cancel();
          timer.cancel();
          Get.offAllNamed(AppRoutes.chargeProcessing, arguments: order);
          return;
        }

        if (status == ChargingStatus.stopped.value) {
          Get.offAllNamed(AppRoutes.charging, arguments: order);
          remainSecondTimer?.cancel();
          timer.cancel();
          return;
        }

        final res = await Api().get(Endpoints.chargingStats(order!.id!));

        if (res.data['status'] >= 200 && res.data['status'] < 300) {
          final data = res.data['data'];

          if (data['charging_stats']['status'] is String) {
            status = data['charging_stats']['status'];
          }
        }

      });
    } catch (e, stackTrace) {
      errorMessage = 'Error: $e, stackTrace: $stackTrace';
      Get.log(errorMessage);
      update();
    }
  }

 Future<void> cancelPending() async{
    try {
      final res = await Api().delete(Endpoints.order(order!.id!));

      if (res.data['status'] == 200) {
        remainSecondTimer?.cancel();
        apiTimer?.cancel();
        status = ChargingStatus.stopped.name;
        update();
        Get.offAllNamed(AppRoutes.charging);
      }

    } catch (e, stackTrace) {
      errorMessage = 'Error: $e, stackTrace: $stackTrace';
      update();
    }
  }
}
