import 'dart:async';

import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/models/charging_stats.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/services/api_service.dart';

class ChargingController extends GetxController {
  ChargingStats? chargingStats;
  Order? currentOrder;
  List<Order> orderHistories = [];

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> fetchChargingHistory({
    Function(String msg)? onErrorCallback,
  }) async {
    try {
      final res = await Api().get(Endpoints.orders);
      dynamic list =
          res.data['data']?['orders'] ??
          res.data['orders'] ??
          res.data['data'] ??
          res.data;
      orderHistories = Order.listFromJson(list);
    } catch (e) {
      onErrorCallback?.call('Error fetching charging history: $e');
      // rethrow;
    } finally {
      update();
    }
  }

  Future<void> fetchChargingOrder({
    Function(String msg)? onErrorCallback,
  }) async {
    try {
      final res = await Api().get(Endpoints.activeOrder);

      if (res.data['status'] >= 200 && res.data['status'] < 300) {
        final data = res.data['data'];
        chargingStats = ChargingStats.fromJson(data['charging_stats']);
        chargingStats?.order = Order.fromJson(data['order']);
        update();
      }
    } catch (e, stackTrace) {
      onErrorCallback?.call('Error fetching charging order: $e, $stackTrace');
    }
  }
}
