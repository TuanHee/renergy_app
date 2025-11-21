class Customer {
  int? customerId;
  String? customerName;
  String? customerPhone;
  String? customerEmail;
  String? customerVehicleModel;
  String? customerVehiclePlate;

  Customer({
    this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    this.customerVehicleModel,
    this.customerVehiclePlate,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      customerId: json['customer_id'] == null ? null : int.parse(json['customer_id'].toString()),
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      customerEmail: json['customer_email'],
      customerVehicleModel: json['customer_vehicle_model'],
      customerVehiclePlate: json['customer_vehicle_plate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id': customerId,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_email': customerEmail,
      'customer_vehicle_model': customerVehicleModel,
      'customer_vehicle_plate': customerVehiclePlate,
    };
  }

  static List<Customer> listFromJson(dynamic json) {
    return json == null ? [] : List<Customer>.from(json.map((x) => Customer.fromJson(x)));
  }
}