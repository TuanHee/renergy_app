import 'package:flutter/material.dart';

class CreditCard {
  final int? id;
  final String last4;
  final String? brand;
  final String? type;
  final bool isDefault;

  CreditCard({
    this.id,
    required this.last4,
    this.brand,
    this.type,
    this.isDefault = false,
  });

  factory CreditCard.fromJson(Map<String, dynamic> json) {
    final id = json['id'] == null ? null : int.tryParse(json['id'].toString());
    final last4 = (json['last4'] ?? json['last_4'] ?? '')
        .toString();
    final brand = json['brand']?.toString();
    final type = json['type']?.toString();
    final isDefault = json['is_default'] ?? false;
    
    return CreditCard(
      id: id,
      last4: last4,
      brand: brand,
      type: type,
      isDefault: isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'last4': last4,
      'brand': brand,
      'type': type,
      'is_default': isDefault,
    };
  }

  String get brandLogo {
    final v = (brand ?? '').toLowerCase();

    if (v.contains('visa')) return 'assets/images/visa_logo.png';
    if (v.contains('master')) return 'assets/images/mastercard_logo.png';
    if (v.contains('amex') || v.contains('american')) return 'assets/images/amex_logo.png';
    if (v.contains('unionpay')) return 'assets/images/unionpay_logo.png';
    return 'assets/images/no_card.png';
  }
}