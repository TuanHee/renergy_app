class OperationTimes {
  int? id;
  int? stationId;
  String? day; // e.g., "Monday"
  String? operationStatus; // e.g., "Open"
  String? operationStart; // HH:mm:ss
  String? operationEnd;   // HH:mm:ss
  String? createdAt; // ISO8601 string
  String? updatedAt; // ISO8601 string

  OperationTimes({
    this.id,
    this.stationId,
    this.day,
    this.operationStatus,
    this.operationStart,
    this.operationEnd,
    this.createdAt,
    this.updatedAt,
  });

  factory OperationTimes.fromJson(Map<String, dynamic> json) {
    return OperationTimes(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      stationId: json['station_id'] == null ? null : int.parse(json['station_id'].toString()),
      day: json['day'],
      operationStatus: json['operation_status'],
      operationStart: json['operation_start'],
      operationEnd: json['operation_end'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'station_id': stationId,
      'day': day,
      'operation_status': operationStatus,
      'operation_start': operationStart,
      'operation_end': operationEnd,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static List<OperationTimes> listFromJson(dynamic json) {
    return json == null ? [] : List<OperationTimes>.from(json.map((x) => OperationTimes.fromJson(x)));
  }

  int getDay() {
    switch (day?.toLowerCase()) {
      case 'monday':
        return DateTime.monday;
      case 'tuesday':
        return DateTime.tuesday;
      case 'wednesday':
        return DateTime.wednesday;
      case 'thursday':
        return DateTime.thursday;
      case 'friday':
        return DateTime.friday;
      case 'saturday': 
        return DateTime.saturday;
      case 'sunday':
        return DateTime.sunday;
      default:
        return DateTime.monday;
    }
  }
}