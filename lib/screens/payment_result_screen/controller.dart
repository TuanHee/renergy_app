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

    order= Order.fromJson({
                "total_usage": 26700,
                "total_chargeable_idle_time_minutes": 22.02,
                "total_charging_time_minutes": 20,
                "id": 1,
                "station_id": 1,
                "bay_id": 1,
                "charger_id": 1,
                "charger_port_id": 1,
                "vehicle_id": 1,
                "customer_id": 1,
                "description": null,
                "customer_name": "Customer",
                "customer_phone": "0163456789",
                "customer_email": "customer@customer.com",
                "customer_vehicle_model": "Toyota",
                "customer_vehicle_plate": "JKK1234",
                "company_name": null,
                "station_name": "Renergy Station",
                "charger_name": "redc0017",
                "charger_serial_number": "redc0017",
                "charger_port_type": null,
                "charger_current_type": "DC",
                "bay_name": "Bay 38",
                "invoice_no": "INV2511-00001",
                "discount_percentage": "0.00",
                "tax_percentage": "0.00",
                "subtotal_amount": "27.50",
                "discount_amount": "0.00",
                "tax_amount": "0.00",
                "net_amount": "27.50",
                "currency_code": "MYR",
                "currency_rate": "1.0000",
                "completed_at": "2025-11-20T09:31:26.000000Z",
                "cancelled_at": null,
                "voided_at": null,
                "status": "Completed",
                "created_at": "2025-11-20T09:31:26.000000Z",
                "updated_at": "2025-11-20T09:31:26.000000Z",
                "lines": [
                    {
                        "id": 1,
                        "order_id": 1,
                        "orderable_type": "App\\Models\\ChargingTransaction",
                        "orderable_id": 1,
                        "quantity": "25.0000",
                        "uom": "kWh",
                        "unit_price": "0.88",
                        "subtotal_amount": "22.00",
                        "discount_percentage": "0.00",
                        "discount_amount": "0.00",
                        "tax_percentage": "0.00",
                        "tax_amount": "0.00",
                        "net_amount": "22.00",
                        "created_at": "2025-11-20T09:31:26.000000Z",
                        "updated_at": "2025-11-20T09:31:26.000000Z",
                        "orderable": {
                            "id": 1,
                            "id_tag": "Go2LHcbpHC70UZ9dNv9F",
                            "order_id": 1,
                            "charger_port_id": 1,
                            "status": "Completed",
                            "started_at": "2025-11-20T09:11:26.000000Z",
                            "stopped_at": "2025-11-20T09:21:26.000000Z",
                            "stop_reason": "Remote",
                            "duration_minutes": "10.00",
                            "meter_start_value": 1500,
                            "meter_stop_value": 26500,
                            "usage": 25000,
                            "created_at": "2025-11-20T08:56:26.000000Z",
                            "updated_at": "2025-11-20T09:31:26.000000Z"
                        }
                    },
                    {
                        "id": 2,
                        "order_id": 1,
                        "orderable_type": "App\\Models\\ChargingTransaction",
                        "orderable_id": 2,
                        "quantity": "1.7000",
                        "uom": "kWh",
                        "unit_price": "0.88",
                        "subtotal_amount": "1.50",
                        "discount_percentage": "0.00",
                        "discount_amount": "0.00",
                        "tax_percentage": "0.00",
                        "tax_amount": "0.00",
                        "net_amount": "1.50",
                        "created_at": "2025-11-20T09:31:26.000000Z",
                        "updated_at": "2025-11-20T09:31:26.000000Z",
                        "orderable": {
                            "id": 2,
                            "id_tag": "WJFYzSdP6oBiP8fsrhu4",
                            "order_id": 1,
                            "charger_port_id": 1,
                            "status": "Completed",
                            "started_at": "2025-11-20T09:26:26.000000Z",
                            "stopped_at": "2025-11-20T09:29:26.000000Z",
                            "stop_reason": "Remote",
                            "duration_minutes": "10.00",
                            "meter_start_value": 26500,
                            "meter_stop_value": 28200,
                            "usage": 1700,
                            "created_at": "2025-11-20T09:23:26.000000Z",
                            "updated_at": "2025-11-20T09:31:26.000000Z"
                        }
                    },
                    {
                        "id": 3,
                        "order_id": 1,
                        "orderable_type": "App\\Models\\ChargingTransaction",
                        "orderable_id": 3,
                        "quantity": "0.0000",
                        "uom": "kWh",
                        "unit_price": "0.88",
                        "subtotal_amount": "0.00",
                        "discount_percentage": "0.00",
                        "discount_amount": "0.00",
                        "tax_percentage": "0.00",
                        "tax_amount": "0.00",
                        "net_amount": "0.00",
                        "created_at": "2025-11-20T09:31:26.000000Z",
                        "updated_at": "2025-11-20T09:31:26.000000Z",
                        "orderable": {
                            "id": 3,
                            "id_tag": "zmC3sF9pKRKe2gQrga72",
                            "order_id": 1,
                            "charger_port_id": 1,
                            "status": "Cancelled",
                            "started_at": null,
                            "stopped_at": null,
                            "stop_reason": null,
                            "duration_minutes": null,
                            "meter_start_value": null,
                            "meter_stop_value": null,
                            "usage": null,
                            "created_at": "2025-11-20T09:31:26.000000Z",
                            "updated_at": "2025-11-20T09:31:26.000000Z"
                        }
                    },
                    {
                        "id": 4,
                        "order_id": 1,
                        "orderable_type": "App\\Models\\IdleTransaction",
                        "orderable_id": 1,
                        "quantity": "0.0000",
                        "uom": "5 minutes",
                        "unit_price": "1.00",
                        "subtotal_amount": "0.00",
                        "discount_percentage": "0.00",
                        "discount_amount": "0.00",
                        "tax_percentage": "0.00",
                        "tax_amount": "0.00",
                        "net_amount": "0.00",
                        "created_at": "2025-11-20T09:31:26.000000Z",
                        "updated_at": "2025-11-20T09:31:26.000000Z",
                        "orderable": {
                            "id": 1,
                            "order_id": 1,
                            "started_at": "2025-11-20T09:29:26.000000Z",
                            "stopped_at": "2025-11-20T09:31:26.000000Z",
                            "grace_period_minutes": 0,
                            "total_idle_time_minutes": "2.02",
                            "chargeable_idle_time_minutes": "2.02",
                            "created_at": "2025-11-20T09:31:26.000000Z",
                            "updated_at": "2025-11-20T09:31:26.000000Z"
                        }
                    },
                    {
                        "id": 5,
                        "order_id": 1,
                        "orderable_type": "App\\Models\\IdleTransaction",
                        "orderable_id": 2,
                        "quantity": "1.0000",
                        "uom": "5 minutes",
                        "unit_price": "1.00",
                        "subtotal_amount": "1.00",
                        "discount_percentage": "0.00",
                        "discount_amount": "0.00",
                        "tax_percentage": "0.00",
                        "tax_amount": "0.00",
                        "net_amount": "1.00",
                        "created_at": "2025-11-20T09:31:26.000000Z",
                        "updated_at": "2025-11-20T09:31:26.000000Z",
                        "orderable": {
                            "id": 2,
                            "order_id": 1,
                            "started_at": "2025-11-20T09:21:26.000000Z",
                            "stopped_at": "2025-11-20T09:26:26.000000Z",
                            "grace_period_minutes": 0,
                            "total_idle_time_minutes": "5.00",
                            "chargeable_idle_time_minutes": "5.00",
                            "created_at": "2025-11-20T09:31:26.000000Z",
                            "updated_at": "2025-11-20T09:31:26.000000Z"
                        }
                    },
                    {
                        "id": 6,
                        "order_id": 1,
                        "orderable_type": "App\\Models\\IdleTransaction",
                        "orderable_id": 3,
                        "quantity": "3.0000",
                        "uom": "5 minutes",
                        "unit_price": "1.00",
                        "subtotal_amount": "3.00",
                        "discount_percentage": "0.00",
                        "discount_amount": "0.00",
                        "tax_percentage": "0.00",
                        "tax_amount": "0.00",
                        "net_amount": "3.00",
                        "created_at": "2025-11-20T09:31:26.000000Z",
                        "updated_at": "2025-11-20T09:31:26.000000Z",
                        "orderable": {
                            "id": 3,
                            "order_id": 1,
                            "started_at": "2025-11-20T08:56:26.000000Z",
                            "stopped_at": "2025-11-20T09:11:26.000000Z",
                            "grace_period_minutes": 0,
                            "total_idle_time_minutes": "15.00",
                            "chargeable_idle_time_minutes": "15.00",
                            "created_at": "2025-11-20T09:31:26.000000Z",
                            "updated_at": "2025-11-20T09:31:26.000000Z"
                        }
                    }
                ]
            });
    amountText = _currency(order?.netAmount);
    _buildItems();
  }

  String _currency(double? v) {
    final val = v ?? 0;
    return 'RM${val.toStringAsFixed(2)}';
  }

  String _s(dynamic v) {
    return v == null ? '-' : v.toString();
  }

  void _add(String k, String? v) {
    if (v == null || v.isEmpty) return;
    items.add({'k': k, 'v': v});
  }

  void _buildItems() {
    items.clear();
    if (order == null) return;
    _add('Invoice No', _s(order!.invoiceNo));
    _add('Completed At', _s(order!.completedAt));
    final location = [order!.station?.address1, order!.station?.address2, order!.station?.state]
        .where((e) => e != null && e.toString().isNotEmpty)
        .join(', ');
    _add('Station Location', location.isEmpty ? null : location);
    _add('Port Type', _s(order?.bay?.port?.portType));
    _add('Total Usage', _s(order!.totalUsage));
    _add('Charging Time (min)', _s(order!.totalChargingTimeMinutes));
    _add('Chargeable Idle (min)', order!.totalChargeableIdleTimeMinutes?.toStringAsFixed(2));
    _add('Subtotal', order!.subtotalAmount == null ? null : _currency(order!.subtotalAmount));
    if (order!.discountPercentage != null) {
      _add('Discount (%)', order!.discountPercentage!.toString());
    } else if (order!.discountAmount != null) {
      _add('Discount Amount', _currency(order!.discountAmount));
    }
    if (order!.taxPercentage != null) {
      _add('Tax (%)', order!.taxPercentage!.toString());
    } else if (order!.taxAmount != null) {
      _add('Tax Amount', _currency(order!.taxAmount));
    }
    _add('Net Amount', order!.netAmount == null ? null : _currency(order!.netAmount));
    if (order!.customer != null) {
      _add('Vehicle Model', _s(order!.customer!.customerVehicleModel));
      _add('Vehicle Plate', _s(order!.customer!.customerVehiclePlate));
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