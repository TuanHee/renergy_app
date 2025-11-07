class ChargingTransaction {
  int? id;
  String? idTag;
  int? chargerPortId;
  String? status;
  String? startedAt;
  String? stoppedAt;
  String? stopReason;
  int? durationMinutes;
  double? meterStartValue;
  double? meterStopValue;
  double? usage;
  String? createdAt;
  String? updatedAt;

  ChargingTransaction({
    this.id,
    this.idTag,
    this.chargerPortId,
    this.status,
    this.startedAt,
    this.stoppedAt,
    this.stopReason,
    this.durationMinutes,
    this.meterStartValue,
    this.meterStopValue,
    this.usage,
    this.createdAt,
    this.updatedAt,
  });

  factory ChargingTransaction.fromJson(Map<String, dynamic> json) {
    return ChargingTransaction(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      idTag: json['id_tag'],
      chargerPortId: json['charger_port_id'] == null ? null : int.parse(json['charger_port_id'].toString()),
      status: json['status'],
      startedAt: json['started_at'],
      stoppedAt: json['stopped_at'],
      stopReason: json['stop_reason'],
      durationMinutes: json['duration_minutes'] == null ? null : int.parse(json['duration_minutes'].toString()),
      meterStartValue: json['meter_start_value'] == null ? null : double.parse(json['meter_start_value'].toString()),
      meterStopValue: json['meter_stop_value'] == null ? null : double.parse(json['meter_stop_value'].toString()),
      usage: json['usage'] == null ? null : double.parse(json['usage'].toString()),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  static List<ChargingTransaction> listFromJson(dynamic json) {
    return json == null ? [] : List<ChargingTransaction>.from(json.map((x) => ChargingTransaction.fromJson(x)));
  }
}

