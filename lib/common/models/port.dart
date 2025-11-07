class Port {
  int? id;
  int? chargerId;
  int? bayId;
  int? connectorId;
  String? outputPower;
  String? outputCurrent;
  String? currentType;
  String? portType;
  String? status;
  bool isActive;
  String? createdAt;
  String? updatedAt;

  Port({
    this.id,
    this.chargerId,
    this.bayId,
    this.connectorId,
    this.outputPower,
    this.outputCurrent,
    this.currentType,
    this.portType,
    this.status,
    this.isActive = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Port.fromJson(Map<String, dynamic> json) {
    return Port(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      chargerId: json['charger_id'] == null ? null : int.parse(json['charger_id'].toString()),
      bayId: json['bay_id'] == null ? null : int.parse(json['bay_id'].toString()),
      connectorId: json['connector_id'] == null ? null : int.parse(json['connector_id'].toString()),
      outputPower: json['output_power'],
      outputCurrent: json['output_current'],
      currentType: json['current_type'],
      portType: json['port_type'],
      status: json['status'],
      isActive: json['is_active'] == null ? false : bool.parse(json['is_active'].toString()),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  static List<Port> listFromJson(dynamic json) {
    return json == null ? [] : List<Port>.from(json.map((x) => Port.fromJson(x)));
  }
}
