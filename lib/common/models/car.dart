class Car {
  final String id;
  final String model;
  final String plate;
  final bool isDefault;

  Car({
    required this.id,
    required this.model,
    required this.plate,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'model': model,
        'plate': plate,
        'is_default': isDefault,
      };

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json['id'],
        model: json['model'],
        plate: json['plate'],
        isDefault: json['is_default'] ?? false,
      );
}