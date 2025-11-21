import 'package:renergy_app/common/models/charging_transaction.dart';

class OrderLine {
  int? id;
  int? orderId;
  String? orderableType;
  int? orderableId;
  double? quantity;
  String? uom;
  double? unitPrice;
  double? subtotalAmount;
  double? discountPercentage;
  double? discountAmount;
  double? taxPercentage;
  double? taxAmount;
  double? netAmount;
  String? createdAt;
  String? updatedAt;
  ChargingTransaction? orderable;

  OrderLine({
    this.id,
    this.orderId,
    this.orderableType,
    this.orderableId,
    this.quantity,
    this.uom,
    this.unitPrice,
    this.subtotalAmount,
    this.discountPercentage,
    this.discountAmount,
    this.taxPercentage,
    this.taxAmount,
    this.netAmount,
    this.createdAt,
    this.updatedAt,
    this.orderable,
  });

  factory OrderLine.fromJson(Map<String, dynamic> json) {
    return OrderLine(
      id: json['id'] == null ? null : int.parse(json['id'].toString()),
      orderId: json['order_id'] == null ? null : int.parse(json['order_id'].toString()),
      orderableType: json['orderable_type'],
      orderableId: json['orderable_id'] == null ? null : int.parse(json['orderable_id'].toString()),
      quantity: json['quantity'] == null ? null : double.parse(json['quantity'].toString()),
      uom: json['uom'],
      unitPrice: json['unit_price'] == null ? null : double.parse(json['unit_price'].toString()),
      subtotalAmount: json['subtotal_amount'] == null ? null : double.parse(json['subtotal_amount'].toString()),
      discountPercentage: json['discount_percentage'] == null ? null : double.parse(json['discount_percentage'].toString()),
      discountAmount: json['discount_amount'] == null ? null : double.parse(json['discount_amount'].toString()),
      taxPercentage: json['tax_percentage'] == null ? null : double.parse(json['tax_percentage'].toString()),
      taxAmount: json['tax_amount'] == null ? null : double.parse(json['tax_amount'].toString()),
      netAmount: json['net_amount'] == null ? null : double.parse(json['net_amount'].toString()),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      orderable: json['orderable'] == null ? null : ChargingTransaction.fromJson(json['orderable']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'orderable_type': orderableType,
      'orderable_id': orderableId,
      'quantity': quantity,
      'uom': uom,
      'unit_price': unitPrice,
      'subtotal_amount': subtotalAmount,
      'discount_percentage': discountPercentage,
      'discount_amount': discountAmount,
      'tax_percentage': taxPercentage,
      'tax_amount': taxAmount,
      'net_amount': netAmount,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'orderable': orderable?.toJson(),
    };
  }

  static List<OrderLine> listFromJson(dynamic json) {
    return json == null ? [] : List<OrderLine>.from(json.map((x) => OrderLine.fromJson(x)));
  }
}

