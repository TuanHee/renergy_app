class Customer {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? nric;
  String? dateOfBirth;
  String? displayCountry;
  String? address1;
  String? address2;
  String? country;
  String? state;
  String? city;
  String? postcode;
  String? status;
  bool? googleConnected;
  bool? facebookConnected;
  bool? appleConnected;
  bool? huaweiConnected;
  int? linkedCreditCardsCount;
  String? favoriteLocation;
  double? totalCharging;
  double? totalSpend;
  String? fcmToken;
  String? createdAt;
  String? updatedAt;

  Customer({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.nric,
    this.dateOfBirth,
    this.displayCountry,
    this.address1,
    this.address2,
    this.country,
    this.state,
    this.city,
    this.postcode,
    this.status,
    this.googleConnected,
    this.facebookConnected,
    this.appleConnected,
    this.huaweiConnected,
    this.linkedCreditCardsCount,
    this.favoriteLocation,
    this.totalCharging,
    this.totalSpend,
    this.fcmToken,
    this.createdAt,
    this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      nric: json['nric'],
      dateOfBirth: json['date_of_birth'],
      displayCountry: json['display_country'],
      address1: json['address_1'],
      address2: json['address_2'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      postcode: json['postcode'],
      status: json['status'],
      googleConnected: json['google_connected'] == null
          ? null
          : bool.parse(json['google_connected'].toString()),
      facebookConnected: json['facebook_connected'] == null
          ? null
          : bool.parse(json['facebook_connected'].toString()),
      appleConnected: json['apple_connected'] == null
          ? null
          : bool.parse(json['apple_connected'].toString()),
      huaweiConnected: json['huawei_connected'] == null
          ? null
          : bool.parse(json['huawei_connected'].toString()),
      linkedCreditCardsCount: json['linked_credit_cards_count'] == null
          ? null
          : int.parse(json['linked_credit_cards_count'].toString()),
      favoriteLocation: json['favorite_location'],
      totalCharging: json['total_charging'] == null
          ? null
          : double.parse(json['total_charging'].toString()),
      totalSpend: json['total_spend'] == null
          ? null
          : double.parse(json['total_spend'].toString()),
      fcmToken: json['fcm_token'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'nric': nric,
      'date_of_birth': dateOfBirth,
      'display_country': displayCountry,
      'address_1': address1,
      'address_2': address2,
      'country': country,
      'state': state,
      'city': city,
      'postcode': postcode,
      'status': status,
      'google_connected': googleConnected,
      'facebook_connected': facebookConnected,
      'apple_connected': appleConnected,
      'huawei_connected': huaweiConnected,
      'linked_credit_cards_count': linkedCreditCardsCount,
      'favorite_location': favoriteLocation,
      'total_charging': totalCharging,
      'total_spend': totalSpend,
      'fcm_token': fcmToken,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  static List<Customer> listFromJson(dynamic json) {
    return json == null ? [] : List<Customer>.from(json.map((x) => Customer.fromJson(x)));
  }
}