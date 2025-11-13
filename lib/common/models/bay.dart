import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/port.dart';


class Bay {
  int? id;
  int? stationId;
  String? name;
  bool isActive;
  bool isInstalled;
  BayStatus? status;
  String? parkingLockSerialNumber;
  String? createdAt;
  String? updatedAt;
  Port? port;

  Bay({
    this.id,
    this.stationId,
    this.name,
    this.isActive = false,
    this.isInstalled = false,
    this.status,
    this.parkingLockSerialNumber,
    this.createdAt,
    this.updatedAt,
    this.port,
  });

  factory Bay.fromJson(Map<String, dynamic> json) {
    return Bay(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      stationId: json['station_id'] == null ? null : int.parse(json['station_id'].toString()),
      name: json['name'],
      isActive: json['is_active'] == null ? false : bool.parse(json['is_active'].toString()),
      isInstalled: json['is_installed'] == null ? false : bool.parse(json['is_installed'].toString()),
      status: json['status'] == null ? null : BayStatus.fromString(json['status']),
      parkingLockSerialNumber: json['parking_lock_serial_number'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      port: json['port'] == null ? null : Port.fromJson(json['port']),
    );
  }

  static List<Bay> listFromJson(dynamic json) {
    return json == null ? [] : List<Bay>.from(json.map((x) => Bay.fromJson(x)));
  }
}