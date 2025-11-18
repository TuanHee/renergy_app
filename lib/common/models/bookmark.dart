import 'package:renergy_app/common/models/station.dart';

class Bookmark {
  int? id;
  int? customerId;
  int? stationId;
  Station? station;
  String? createdAt;
  String? updatedAt;

  Bookmark({
    this.id,
    this.customerId,
    this.stationId,
    this.station,
    this.createdAt,
    this.updatedAt,
  });

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      customerId: json['customer_id'] == null ? null : int.parse(json['customer_id'].toString()),
      stationId: json['station_id'] == null ? null : int.parse(json['station_id'].toString()),
      station: json['station'] == null ? null : Station.fromJson(json['station']),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'station_id': stationId,
      'station': station?.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static List<Bookmark> listFromJson(dynamic json) {
    return json == null ? [] : List<Bookmark>.from(json.map((x) => Bookmark.fromJson(x)));
  }
}