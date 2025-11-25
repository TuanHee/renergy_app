import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/charging_stats.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/screens/explorer_screen/controller.dart';

class ChargingController extends GetxController {
  ChargingStatsStatus status = ChargingStatsStatus.none;
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
        final newStatus = ChargingStatsStatus.fromString(data['status']);
        final newOrder = data['order'] != null
            ? Order.fromJson(data['order'])
            : null;
        final changedStatus = newStatus != null && status != newStatus;
        final changedOrder = (currentOrder?.id ?? -1) != (newOrder?.id ?? -1);

        if (changedStatus || changedOrder) {
          status = newStatus ?? status;
          currentOrder = newOrder;

          update();
        }
      }
    } catch (e, stackTrace) {
      onErrorCallback?.call('Error polling charging order: $e, $stackTrace');
    }
  }
}
