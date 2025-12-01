import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/constants.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentResultController extends GetxController {
  Order? order;
  List<Map<String, String>> items = [];
  bool isDownloading = false;

  @override
  void onInit() async{
    super.onInit();
    final args = Get.arguments;
    if (args is Order) {
      order = args;
    } else if (args is Map && args['order'] != null) {
      order = Order.fromJson(args['order']);
    }

    await fetchOrder();

    buildItems();
  }

  Future<void> fetchOrder({
    Function(String msg)? onErrorCallback,
  }) async {
    try {
      if(order?.id == null) throw('Order id is null');
      final res = await Api().get(Endpoints.order(order!.id!));

      if (res.data['status'] >= 200 && res.data['status'] < 300) {
        final data = res.data['data'];
        order = Order.fromJson(data['order']);
        update();
      }
    } catch (e, stackTrace) {
      onErrorCallback?.call('Error fetch order: $e, $stackTrace');
    }
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
    addSummaryItem(
      'Station',
      toDisplayString(order!.stationName ?? order!.station?.name),
    );
    addSummaryItem(
      'Total Usage',
      toDisplayString(
        '${((order!.totalUsage ?? 0) / 1000).toStringAsFixed(1)} kWh',
      ),
    );
    addSummaryItem(
      'Charging Time (min)',
      toDisplayString(order!.totalChargingTimeMinutes),
    );
    addSummaryItem(
      'Chargeable Idle (min)',
      order!.totalChargeableIdleTimeMinutes?.toStringAsFixed(2),
    );
    addSummaryItem(
      'Subtotal',
      order!.subtotalAmount == null
          ? null
          : formatCurrency(order!.subtotalAmount),
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
      addSummaryItem(
        'Vehicle Model',
        toDisplayString(order!.customer!.vehicleModel),
      );
      addSummaryItem(
        'Vehicle Plate',
        toDisplayString(order!.customer!.vehiclePlate),
      );
    }
  }

  void goToCharging() {
    Get.offAllNamed(AppRoutes.charging);
  }

  void downloadInvoice({Function(String)? onError}) async {
    isDownloading = true;
    update();
    try {
      if (order?.id == null) throw 'No Order Id';
      final uri = Uri.parse('$httpBaseUrl/${Endpoints.pdf(order!.id!)}');
      // final canLaunch = await canLaunchUrl(uri);
      final canLaunch = true;
      if (!canLaunch) throw 'Cannot open invoice link';
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView,);

    } catch (e) {
      onError?.call(e.toString());
      Get.snackbar(
        'Download Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFD32F2F),
        colorText: Colors.white,
      );
    }
    finally{
      isDownloading = false;
    update();
    }
  }
}
