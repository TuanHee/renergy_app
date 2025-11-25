import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/routes/app_routes.dart';

class PaymentResultController extends GetxController {
  Order? order;
  String amountText = 'RM0.00';
  List<Map<String, String>> items = [];

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Order) {
      order = args;
    } else if (args is Map && args['order'] != null) {
      order = Order.fromJson(args['order']);
    }

    amountText = formatCurrency(order?.netAmount);
    buildItems();
  }

  String formatCurrency(double? v) {
    final val = v ?? 0;
    return 'RM${val.toStringAsFixed(2)}';
  }

  String toDisplayString(dynamic v) {
    return v == null ? '-' : v.toString();
  }

  void addSummaryItem(String label, String? value) {
    if (value == null || value.isEmpty) return;
    items.add({'label': label, 'value': value});
  }

  void buildItems() {
    items.clear();
    if (order == null) return;
    addSummaryItem('Station', toDisplayString(order!.stationName ?? order!.station?.name));
    addSummaryItem(
      'Total Usage',
      toDisplayString('${((order!.totalUsage ?? 0) / 1000).toStringAsFixed(1)} kWh'),
    );
    addSummaryItem('Charging Time (min)', toDisplayString(order!.totalChargingTimeMinutes));
    addSummaryItem(
      'Chargeable Idle (min)',
      order!.totalChargeableIdleTimeMinutes?.toStringAsFixed(2),
    );
    addSummaryItem(
      'Subtotal',
      order!.subtotalAmount == null ? null : formatCurrency(order!.subtotalAmount),
    );
    if (order!.discountPercentage != null) {
      addSummaryItem('Discount (%)', order!.discountPercentage!.toString());
    } else if (order!.discountAmount != null) {
      addSummaryItem('Discount Amount', formatCurrency(order!.discountAmount));
    }
    if (order!.taxPercentage != null) {
      addSummaryItem('Tax (%)', order!.taxPercentage!.toString());
    } else if (order!.taxAmount != null) {
      addSummaryItem('Tax Amount', formatCurrency(order!.taxAmount));
    }
    addSummaryItem(
      'Net Amount',
      order!.netAmount == null ? null : formatCurrency(order!.netAmount),
    );
    if (order!.customer != null) {
      addSummaryItem('Vehicle Model', toDisplayString(order!.customer!.customerVehicleModel));
      addSummaryItem('Vehicle Plate', toDisplayString(order!.customer!.customerVehiclePlate));
    }
  }

  void goToCharging() {
    Get.offAllNamed(AppRoutes.charging);
  }

  void downloadInvoice() {
    Get.snackbar(
      'Download',
      'Downloading invoice...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF4CAF50),
      colorText: Colors.white,
    );
  }
}