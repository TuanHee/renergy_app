import 'dart:async';

import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';

class MainController extends GetxController {
  Order? chargingOrder;
  String? status;
  Timer? chargingOrderTimer;

  Future<void> pollChargingOrder() async {
    chargingOrderTimer = Timer.periodic(const Duration(seconds: 2), (
      timer,
    ) async {
      try {
        // if (status == ChargingStatus.charging.value) {
        //   timer.cancel();
        //   Get.offAllNamed(AppRoutes.chargeProcessing, arguments: chargingOrder);
        //   return;
        // }

        // if (status == ChargingStatus.stopped.value) {
        //   Get.offAllNamed(AppRoutes.charging, arguments: chargingOrder);
        //   timer.cancel();
        //   return;
        // }

        final res = await Api().get(Endpoints.activeOrder);

        if (res.data['status'] >= 200 && res.data['status'] < 300) {
          final data = res.data['data'];

          status = data['status'];
          chargingOrder = data['order'] != null
              ? Order.fromJson(data['order'])
              : null;
        }
      } catch (e, stackTrace) {
        print('Error polling charging order: $e, $stackTrace');
      }
      finally{
        update();
      }
    });
  }

  @override
  void onClose() {
    chargingOrderTimer?.cancel();
    super.onClose();
  }
}
