import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/meter.dart';

class ChargingStats {
  ChargingStatsStatus? status;
  String? startAt;
  String? stopAt;
  Meter? meter;

  ChargingStats({
    this.status,
    this.startAt,
    this.stopAt,
    this.meter,
  });

  factory ChargingStats.fromJson(Map<String, dynamic> json) {
    return ChargingStats(
      status: ChargingStatsStatus.fromString(json['status']),
      startAt: json['start_at'],
      stopAt: json['stop_at'],
      meter: json['meter'] == null ? null : Meter.fromJson(json['meter']),
    );
  }

  static List<ChargingStats> listFromJson(dynamic json) {
    return json == null ? [] : List<ChargingStats>.from(json.map((x) => ChargingStats.fromJson(x)));
  }
}

