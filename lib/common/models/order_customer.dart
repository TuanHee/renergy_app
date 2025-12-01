class OrderCustomer {
  int? id;
  String? name;
  String? phone;
  String? mail;
  String? vehicleModel;
  String? vehiclePlate;

  OrderCustomer({
    this.id,
    this.name,
    this.phone,
    this.mail,
    this.vehicleModel,
    this.vehiclePlate,
  });

  factory OrderCustomer.fromJson(Map<String, dynamic> json) {
    return OrderCustomer(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      name: json['name'],
      phone: json['phone'],
      mail: json['mail'],
      vehicleModel: json['vehicle_model'],
      vehiclePlate: json['vehicle_plate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name, 
      'phone': phone,
      'mail': mail,
      'vehicle_model': vehicleModel,
      'vehicle_plate': vehiclePlate,
    };
  }

  static List<OrderCustomer> listFromJson(dynamic json) {
    return json == null ? [] : List<OrderCustomer>.from(json.map((x) => OrderCustomer.fromJson(x)));
  }
}