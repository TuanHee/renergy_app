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

  List<Color> get brandColors {
    final v = (brand ?? '').toLowerCase();
    if (v.contains('visa')) {
      return [Colors.blue.shade700, Colors.blue.shade900];
    }
    if (v.contains('master')) {
      return [Colors.orange.shade700, Colors.red.shade700];
    }
    if (v.contains('amex') || v.contains('american')) {
      return [Colors.teal.shade700, Colors.teal.shade900];
    }
    if (v.contains('discover')) {
      return [Colors.purple.shade700, Colors.purple.shade900];
    }
    return [Colors.grey.shade600, Colors.grey.shade800];
  }

  String get brandLogo {
    final v = (brand ?? '').toLowerCase();
    if (v.contains('visa')) return 'images/visa_logo.png';
    if (v.contains('master')) return 'images/mastercard_logo.png';
    if (v.contains('amex') || v.contains('american')) return 'images/amex_logo.png';
    if (v.contains('discover')) return 'images/discover_logo.png';
    return 'images/card_logo.png';
  }

  IconData get typeIcon {
    final v = (type ?? '').toLowerCase();
    if (v.contains('visa')) return Icons.credit_card;
    return Icons.card_giftcard;
  }
}