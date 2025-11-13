import 'package:renergy_app/common/models/bay.dart';
import 'package:renergy_app/common/models/order_line.dart';
import 'package:renergy_app/common/models/station.dart';

class Order {
  int? id;
  int? stationId;
  Station? station;
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
    this.station,
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
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station_id': stationId,
      'station': station?.toJson(),
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
    };
  }

  static List<Order> listFromJson(dynamic json) {
    return json == null ? [] : List<Order>.from(json.map((x) => Order.fromJson(x)));
  }
}

