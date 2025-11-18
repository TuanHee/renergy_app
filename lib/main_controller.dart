import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/services/api_service.dart';

class MainController extends GetxController {
  Order? chargingOrder;

  Future<void> fetchChargingOrder() async {
    final res = await Api().post(Endpoints.isChanging);

    if (res.data['status'] != 200) {
      throw ('Is Changing Error: ${res.data['message'] ?? 'Unknown error'}');
    }

    // chargingOrder = res.data['data'] as Order;
  }
}

