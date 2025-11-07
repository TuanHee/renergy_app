class Meter {
  int? usage;
  int? soc;
  String? timestamp;

  Meter({
    this.usage,
    this.soc,
    this.timestamp,
  });

  factory Meter.fromJson(Map<String, dynamic> json) {
    return Meter(
      usage: json['usage'] == null ? null : int.parse(json['usage'].toString()),
      soc: json['soc'] == null ? null : int.parse(json['soc'].toString()),
      timestamp: json['timestamp'],
    );
  }

  static List<Meter> listFromJson(dynamic json) {
    return json == null ? [] : List<Meter>.from(json.map((x) => Meter.fromJson(x)));
  }
}

