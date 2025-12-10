import 'package:renergy_app/common/models/bay.dart';
import 'package:renergy_app/common/models/order_line.dart';
import 'package:renergy_app/common/models/station.dart';
import 'package:renergy_app/common/models/order_customer.dart';

import 'idle_times.dart';
import 'operation_times.dart';
import 'port.dart';

class Order {
  int? id;
  String? mainImageUrl;
  int? stationId;
  Station? station;
  String? stationName;
  int? bayId;
  int? chargerId;
  int? chargerPortId;
  int? vehicleId;
  int? userId;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<OrderLine>? lines;
  Bay? bay;
  String? bayName;
  double? totalUsage; 
  double? totalChargeableIdleTimeMinutes;
  double? totalChargingTimeMinutes;
  double? charging_price;
  double? idle_price;
  String? invoiceNo;
  double? discountPercentage;
  double? taxPercentage;
  double? subtotalAmount;
  double? discountAmount;
  double? taxAmount;
  double? netAmount;
  String? completedAt;
  OrderCustomer? customer;
  Port? port;

  Order({
    this.id,
    this.mainImageUrl,
    this.stationId,
    this.station,
    this.stationName,
    this.bayId,
    this.chargerId,
    this.chargerPortId,
    this.vehicleId,
    this.userId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.lines,
    this.bay,
    this.bayName,
    this.totalUsage,
    this.totalChargeableIdleTimeMinutes,
    this.totalChargingTimeMinutes,
    this.charging_price,
    this.idle_price,
    this.invoiceNo,
    this.discountPercentage,
    this.taxPercentage,
    this.subtotalAmount,
    this.discountAmount,
    this.taxAmount,
    this.netAmount,
    this.completedAt,
    this.customer,
    this.port,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      mainImageUrl: json['main_image_url'],
      stationId: json['station_id'] == null ? null : int.parse(json['station_id'].toString()),
      stationName: json['station_name'],
      station: json['station'] == null ? null : Station.fromJson(json['station']),
      bayId: json['bay_id'] == null ? null : int.parse(json['bay_id'].toString()),
      chargerId: json['charger_id'] == null ? null : int.parse(json['charger_id'].toString()),
      chargerPortId: json['charger_port_id'] == null ? null : int.parse(json['charger_port_id'].toString()),
      vehicleId: json['vehicle_id'] == null ? null : int.parse(json['vehicle_id'].toString()),
      userId: json['user_id'] == null ? null : int.parse(json['user_id'].toString()),
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      lines: json['lines'] == null ? null : OrderLine.listFromJson(json['lines']),
      bay: json['bay'] == null ? null : Bay.fromJson(json['bay']),
      bayName: json['bay_name'],
      totalUsage: json['total_usage'] == null ? null : double.parse(json['total_usage'].toString()),
      totalChargeableIdleTimeMinutes: json['total_chargeable_idle_time_minutes'] == null
          ? null
          : double.parse(json['total_chargeable_idle_time_minutes'].toString()),
      totalChargingTimeMinutes: json['total_charging_time_minutes'] == null
          ? null
          : double.parse(json['total_charging_time_minutes'].toString()),
      charging_price: json['fees'] != null && json['fees']['charging_price'] != null
          ? double.parse(json['fees']['charging_price'].toString())
          : null,
      idle_price: json['fees'] != null && json['fees']['idle_price'] != null
          ? double.parse(json['fees']['idle_price'].toString())
          : null,
      invoiceNo: json['invoice_no'],
      discountPercentage: json['discount_percentage'] == null ? null : double.parse(json['discount_percentage'].toString()),
      taxPercentage: json['tax_percentage'] == null ? null : double.parse(json['tax_percentage'].toString()),
      subtotalAmount: json['subtotal_amount'] == null ? null : double.parse(json['subtotal_amount'].toString()),
      discountAmount: json['discount_amount'] == null ? null : double.parse(json['discount_amount'].toString()),
      taxAmount: json['tax_amount'] == null ? null : double.parse(json['tax_amount'].toString()),
      netAmount: json['net_amount'] == null ? null : double.parse(json['net_amount'].toString()),
      completedAt: json['completed_at'],
      customer: json['customer'] != null
          ? OrderCustomer.fromJson(json['customer'])
          : (json['customer_id'] != null ||
                  json['customer_name'] != null ||
                  json['customer_phone'] != null ||
                  json['customer_email'] != null ||
                  json['customer_vehicle_model'] != null ||
                  json['customer_vehicle_plate'] != null)
              ? OrderCustomer.fromJson(json)
              : null,
      port: json['charger_port'] == null ? null : Port.fromJson(json['charger_port']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'main_image_url': mainImageUrl,
      'station_id': stationId,
      'station': station?.toJson(),
      'station_name': stationName,
      'bay_id': bayId,
      'charger_id': chargerId,
      'charger_port_id': chargerPortId,
      'vehicle_id': vehicleId,
      'user_id': userId,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'lines': lines?.map((line) => line.toJson()).toList(),
      'bay': bay?.toJson(),
      'bay_name': bayName,
      'total_usage': totalUsage,
      'total_chargeable_idle_time_minutes': totalChargeableIdleTimeMinutes,
      'total_charging_time_minutes': totalChargingTimeMinutes,
      'fees': {
        'charging_price': charging_price,
        'idle_price': idle_price,
      },
      'invoice_no': invoiceNo,
      'discount_percentage': discountPercentage,
      'tax_percentage': taxPercentage,
      'subtotal_amount': subtotalAmount,
      'discount_amount': discountAmount,
      'tax_amount': taxAmount,
      'net_amount': netAmount,
      'completed_at': completedAt,
      'customer': customer?.toJson(),
      'charger_port': port?.toJson(),
    };
  }

  static List<Order> listFromJson(dynamic json) {
    return json == null ? [] : List<Order>.from(json.map((x) => Order.fromJson(x)));
  }
}

