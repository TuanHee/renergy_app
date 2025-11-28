import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/meter.dart';
import 'package:renergy_app/common/models/order.dart';

class ChargingStats {
  ChargingStatsStatus? status;
  String? startAt;
  String? stopAt;
  Meter? meter;
  Order? order;

  ChargingStats({
    this.status,
    this.startAt,
    this.stopAt,
    this.meter,
  });

  factory ChargingStats.fromJson(Map<String, dynamic> json) {
    return ChargingStats(
      status: ChargingStatsStatus.fromString(json['status']),
      startAt: json['started_at'],
      stopAt: json['stopped_at'],
      meter: json['meter'] == null ? null : Meter.fromJson(json['meter']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status?.value,
      'started_at': startAt,
      'stopped_at': stopAt,
      'meter': meter?.toJson(),
    };
  }

  static List<ChargingStats> listFromJson(dynamic json) {
    return json == null ? [] : List<ChargingStats>.from(json.map((x) => ChargingStats.fromJson(x)));
  }
}

