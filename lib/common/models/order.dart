import 'package:renergy_app/common/models/bay.dart';
import 'package:renergy_app/common/models/order_line.dart';

class Order {
  int? id;
  int? stationId;
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

  Order({
    this.id,
    this.stationId,
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
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      stationId: json['station_id'] == null ? null : int.parse(json['station_id'].toString()),
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
    );
  }

  static List<Order> listFromJson(dynamic json) {
    return json == null ? [] : List<Order>.from(json.map((x) => Order.fromJson(x)));
  }
}

