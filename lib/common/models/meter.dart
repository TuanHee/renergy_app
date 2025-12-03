class Meter {
  int? usage;
  int? soc;
  int? power;
  String? timestamp;

  Meter({
    this.usage,
    this.soc,
    this.power,
    this.timestamp,
  });

  factory Meter.fromJson(Map<String, dynamic> json) {
    return Meter(
      usage: json['usage'] == null ? null : int.parse(json['usage'].toString()),
      soc: json['soc'] == null ? null : int.parse(json['soc'].toString()),
      power: json['power'] == null ? null : int.parse(json['power'].toString()),
      timestamp: json['timestamp'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'usage': usage,
      'soc': soc,
      'power': power,
      'timestamp': timestamp,
    };
  }

  static List<Meter> listFromJson(dynamic json) {
    return json == null ? [] : List<Meter>.from(json.map((x) => Meter.fromJson(x)));
  }
}

