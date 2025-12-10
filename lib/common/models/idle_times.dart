class IdleTimes {
  int? id;
  int? stationId;
  String? day; // e.g., "Thursday"
  String? idleStart; // HH:mm:ss
  String? idleEnd;   // HH:mm:ss
  String? createdAt; // ISO8601 string
  String? updatedAt; // ISO8601 string

  IdleTimes({
    this.id,
    this.stationId,
    this.day,
    this.idleStart,
    this.idleEnd,
    this.createdAt,
    this.updatedAt,
  });

  factory IdleTimes.fromJson(Map<String, dynamic> json) {
    return IdleTimes(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      stationId: json['station_id'] == null ? null : int.parse(json['station_id'].toString()),
      day: json['day'],
      idleStart: json['idle_start'],
      idleEnd: json['idle_end'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station_id': stationId,
      'day': day,
      'idle_start': idleStart,
      'idle_end': idleEnd,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static List<IdleTimes> listFromJson(dynamic json) {
    return json == null ? [] : List<IdleTimes>.from(json.map((x) => IdleTimes.fromJson(x)));
  }
}