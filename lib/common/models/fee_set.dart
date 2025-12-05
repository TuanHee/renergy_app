class PriceList {
  int? id;
  int? feeSetId;
  String? type; // "AC" or "DC"
  int? maxUsage;
  double? price;
  String? createdAt;
  String? updatedAt;

  PriceList({
    this.id,
    this.feeSetId,
    this.type,
    this.maxUsage,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory PriceList.fromJson(Map<String, dynamic> json) {
    return PriceList(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      feeSetId: json['fee_set_id'] == null ? null : int.parse(json['fee_set_id'].toString()),
      type: json['type'],
      maxUsage: json['max_usage'] == null ? null : int.parse(json['max_usage'].toString()),
      price: json['price'] == null ? null : double.parse(json['price'].toString()),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fee_set_id': feeSetId,
      'type': type,
      'max_usage': maxUsage,
      'price': price,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static List<PriceList> listFromJson(dynamic json) {
    return json == null ? [] : List<PriceList>.from(json.map((x) => PriceList.fromJson(x)));
  }
}

class FeeSet {
  int? id;
  String? name;
  String? country;
  double? defaultAcPrice;
  double? defaultDcPrice;
  int? usagePerUnit;
  String? uomLabel;
  double? idleFeePrice;
  int? idleFeeMinutesPerUnit;
  double? highOccupancyFee;
  double? highOccupancyPercentage;
  double? highOccupancyMaxAmount;
  String? platformChargeType;
  double? platformChargePercentage;
  double? minimumChargeAmount;
  int? minimumChargingMinutes;
  String? createdAt;
  String? updatedAt;
  List<PriceList> tiersAc;
  List<PriceList> tiersDc;

  FeeSet({
    this.id,
    this.name,
    this.country,
    this.defaultAcPrice,
    this.defaultDcPrice,
    this.usagePerUnit,
    this.uomLabel,
    this.idleFeePrice,
    this.idleFeeMinutesPerUnit,
    this.highOccupancyFee,
    this.highOccupancyPercentage,
    this.highOccupancyMaxAmount,
    this.platformChargeType,
    this.platformChargePercentage,
    this.minimumChargeAmount,
    this.minimumChargingMinutes,
    this.createdAt,
    this.updatedAt,
    List<PriceList>? tiersAc,
    List<PriceList>? tiersDc,
  })  : tiersAc = tiersAc ?? [],
        tiersDc = tiersDc ?? [];

  factory FeeSet.fromJson(Map<String, dynamic> json) {
    final tiers = json['tiers'] as Map<String, dynamic>?;
    final acJson = tiers == null ? null : tiers['AC'];
    final dcJson = tiers == null ? null : tiers['DC'];

    return FeeSet(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      name: json['name'],
      country: json['country'],
      defaultAcPrice: json['default_ac_price'] == null ? null : double.parse(json['default_ac_price'].toString()),
      defaultDcPrice: json['default_dc_price'] == null ? null : double.parse(json['default_dc_price'].toString()),
      usagePerUnit: json['usage_per_unit'] == null ? null : int.parse(json['usage_per_unit'].toString()),
      uomLabel: json['uom_label'],
      idleFeePrice: json['idle_fee_price'] == null ? null : double.parse(json['idle_fee_price'].toString()),
      idleFeeMinutesPerUnit: json['idle_fee_minutes_per_unit'] == null ? null : int.parse(json['idle_fee_minutes_per_unit'].toString()),
      highOccupancyFee: json['high_occupancy_fee'] == null ? null : double.parse(json['high_occupancy_fee'].toString()),
      highOccupancyPercentage: json['high_occupancy_percentage'] == null ? null : double.parse(json['high_occupancy_percentage'].toString()),
      highOccupancyMaxAmount: json['high_occupancy_max_amount'] == null ? null : double.parse(json['high_occupancy_max_amount'].toString()),
      platformChargeType: json['platform_charge_type'],
      platformChargePercentage: json['platform_charge_percentage'] == null ? null : double.parse(json['platform_charge_percentage'].toString()),
      minimumChargeAmount: json['minimum_charge_amount'] == null ? null : double.parse(json['minimum_charge_amount'].toString()),
      minimumChargingMinutes: json['minimum_charging_minutes'] == null ? null : int.parse(json['minimum_charging_minutes'].toString()),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      tiersAc: PriceList.listFromJson(acJson),
      tiersDc: PriceList.listFromJson(dcJson),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'default_ac_price': defaultAcPrice,
      'default_dc_price': defaultDcPrice,
      'usage_per_unit': usagePerUnit,
      'uom_label': uomLabel,
      'idle_fee_price': idleFeePrice,
      'idle_fee_minutes_per_unit': idleFeeMinutesPerUnit,
      'high_occupancy_fee': highOccupancyFee,
      'high_occupancy_percentage': highOccupancyPercentage,
      'high_occupancy_max_amount': highOccupancyMaxAmount,
      'platform_charge_type': platformChargeType,
      'platform_charge_percentage': platformChargePercentage,
      'minimum_charge_amount': minimumChargeAmount,
      'minimum_charging_minutes': minimumChargingMinutes,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'tiers': {
        'AC': tiersAc.map((t) => t.toJson()).toList(),
        'DC': tiersDc.map((t) => t.toJson()).toList(),
      },
    };
  }

  static List<FeeSet> listFromJson(dynamic json) {
    return json == null ? [] : List<FeeSet>.from(json.map((x) => FeeSet.fromJson(x)));
  }
}