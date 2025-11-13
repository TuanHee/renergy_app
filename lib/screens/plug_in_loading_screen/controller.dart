import 'dart:async';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/components/components.dart';

class PlugInLoadingController extends GetxController {
  Order? order;
  String status = 'ready';
  int remainSecond = 10 * 60;

  Timer? remainSecondTimer;

  @override
  void onInit() async {
    super.onInit();
    order = Get.arguments as Order;

    pollPlugStatus();
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
      Timer.periodic(const Duration(seconds: 2), (timer) async {
        if (status == ChargingStatus.charging.name || status == ChargingStatus.stopped.name) {
          timer.cancel();
          return;
        }

        final res = await Api().get(Endpoints.chargingStats(order!.id!));

        Get.log(
          'Polling charger status: ${res.data['data']['charging_stats']['status']}',
        );

        if (res.data['status'] == 400) {
          final data = res.data['data'];

          if (data['charging_stats']['status'] is String) {
            status = data['charging_stats']['status'];
          }
        }
      });

      Get.offAllNamed(AppRoutes.chargeProcessing);
    } catch (e, stackTrace) {
      Get.log('Error: $e, stackTrace: $stackTrace');
    }
  }

 Future<void> cancelPending() async{
    try {
      final res = await Api().delete(Endpoints.order(order!.id!));

      if (res.data['status'] == 200) {
        remainSecondTimer?.cancel();
        status = ChargingStatus.stopped.name;
        update();
      }

    } catch (e) {
      Snackbar.showError('Error ${ e.toString()}',Get.context!);
    }
  }
}
