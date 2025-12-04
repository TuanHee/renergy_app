import 'package:renergy_app/common/models/bay.dart';
import 'package:geolocator/geolocator.dart';

class Station {
  int? id;
  int? companyId;
  String? name;
  String? type;
  String? category;
  String? shortDescription;
  String? description;
  List<String>? images;
  bool isActive;
  String? address1;
  String? address2;
  String? state;
  int? countryId;
  String? latitude;
  String? longitude;
  String? maxCurrent;
  bool isAllowReserve;
  int? feeSetId;
  String? createdAt;
  String? updatedAt;
  List<Bay>? bays;

  Station({
    this.id,
    this.companyId,
    this.name,
    this.type,
    this.category,
    this.shortDescription,
    this.description,
    this.images,
    this.isActive = false,
    this.address1,
    this.address2,
    this.state,
    this.countryId,
    this.latitude,
    this.longitude,
    this.maxCurrent,
    this.isAllowReserve = false,
    this.feeSetId,
    this.createdAt,
    this.updatedAt,
    this.bays,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      companyId: json['company_id'] == null
          ? null
          : int.parse(json['company_id'].toString()),
      name: json['name'],
      type: json['type'],
      category: json['category'],
      shortDescription: json['short_description'],
      description: json['description'],
      images: json['images'] == null
          ? null
          : List<String>.from(json['images'].map((x) => x.toString())),
      isActive: json['is_active'] == null
          ? false
          : bool.parse(json['is_active'].toString()),
      address1: json['address1'],
      address2: json['address2'],
      state: json['state'],
      countryId: json['country_id'] == null
          ? null
          : int.parse(json['country_id'].toString()),
      latitude: json['latitude'],
      longitude: json['longitude'],
      maxCurrent: json['max_current'],
      isAllowReserve: json['is_allow_reserve'] == null
          ? false
          : bool.parse(json['is_allow_reserve'].toString()),
      feeSetId: json['fee_set_id'] == null
          ? null
          : int.parse(json['fee_set_id'].toString()),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      bays: json['bays'] == null ? null : Bay.listFromJson(json['bays']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'company_id': companyId,
      'name': name,
      'type': type,
      'category': category,
      'short_description': shortDescription,
      'description': description,
      'images': images,
      'is_active': isActive,
      'address1': address1,
      'address2': address2,
      'state': state,
      'country_id': countryId,
      'latitude': latitude,
      'longitude': longitude,
      'max_current': maxCurrent,
      'is_allow_reserve': isAllowReserve,
      'fee_set_id': feeSetId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'bays': bays?.map((b) => b.toJson()).toList(),
    };
  }

  static List<Station> listFromJson(dynamic json) {
    return json == null
        ? []
        : List<Station>.from(json.map((x) => Station.fromJson(x)));
  }

  double distanceTo(Position position) {
    final lat = double.tryParse(latitude ?? '');
    final lon = double.tryParse(longitude ?? '');
    if (lat == null || lon == null) return double.maxFinite;
    return Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          lat,
          lon,
        ) /
        1000;
  }
}
