import 'package:flutter/material.dart';

class CreditCard {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;
  final String cvv;
  final CardType cardType;

  CreditCard({
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
    required this.cvv,
    required this.cardType,
  });
}

enum CardType {
  visa,
  mastercard,
  amex,
  discover;

  String get name {
    switch (this) {
      case CardType.visa:
        return 'Visa';
      case CardType.mastercard:
        return 'Mastercard';
      case CardType.amex:
        return 'American Express';
      case CardType.discover:
        return 'Discover';
    }
  }

  List<Color> get colors {
    switch (this) {
      case CardType.visa:
        return [Colors.blue.shade700, Colors.blue.shade900];
      case CardType.mastercard:
        return [Colors.orange.shade700, Colors.red.shade700];
      case CardType.amex:
        return [Colors.teal.shade700, Colors.teal.shade900];
      case CardType.discover:
        return [Colors.purple.shade700, Colors.purple.shade900];
    }
  }

  IconData get icon {
    switch (this) {
      case CardType.visa:
      case CardType.mastercard:
      case CardType.amex:
      case CardType.discover:
        return Icons.credit_card;
    }
  }

  String get logo {
    // Placeholder paths - replace with actual asset paths
    switch (this) {
      case CardType.visa:
        return 'assets/visa_logo.png';
      case CardType.mastercard:
        return 'assets/mastercard_logo.png';
      case CardType.amex:
        return 'assets/amex_logo.png';
      case CardType.discover:
        return 'assets/discover_logo.png';
    }
  }
}