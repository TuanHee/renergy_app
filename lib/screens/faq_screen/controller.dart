import 'package:get/get.dart';

class FaqItem {
  final String question;
  final String answer;
  final String category; // 'charging' or 'pricing'
  bool expanded;
  FaqItem({required this.question, required this.answer, required this.category, this.expanded = false});
}

class FaqController extends GetxController {
  final items = <FaqItem>[
    FaqItem(
      question: 'How do I start a charging session at Renergy?',
      answer:
          'After signing up for an account and entering your credit card details at the Payment Gateway, enter the Chargepoint you located at, select the correct charger number that match your charging bay. Plug your cable into both charger and vehicle. Press "Charge" to charge, and "End Charging" to stop charging.\n\nNote that RM1.01 will be charged upon registration of your credit card for card authorisation during registration by Fiuu and it\'s non-refundable.',
      category: 'charging',
    ),
    FaqItem(
      question: 'What credit/debit cards are supported?',
      answer: 'We only accept Visa & Mastercard.',
      category: 'charging',
    ),
    FaqItem(
      question: 'What is a charging idle fee?',
      answer:
          'Idle fee of RM1 every 5 minutes will be applied:\n\n1. Before Charging: If you arrive at the bay but do not start charging within 15 minutes.\n\n2. After Charging: If your vehicle is fully charged but you do not remove it within 15 minutes.\n\nPlease remove your car promptly to avoid idle fee.',
      category: 'charging',
    ),
    FaqItem(
      question: 'How can I access a restricted charger?',
      answer:
          'To access a restricted charger, you have to obtain approval from the management of the building in order to access the charger facilities.',
      category: 'charging',
    ),
    FaqItem(
      question: 'I\'m having trouble charging my vehicle. What should I do?',
      answer:
          '1. Ensure you have selected the correct bay number on the app and that it matches the charger\'s bay number.\n\n2. Check the charging port for any dirt or obstructions that might prevent proper connection.\n\n3. If everything seems connected properly and the issue persists, please contact us via WhatsApp for assistance.',
      category: 'charging',
    ),
    FaqItem(
      question:
          'Why am I only getting 7 kW instead of 22 kW when using a 22 kW AC charger?',
      answer:
          'Your vehicle\'s charging speed depends on its onboard charger capacity. If your EV is only equipped to accept 7 kW, the onboard charger will limit the power to that level.\n\nHere are a few key points to consider:\n1. The onboard charger in your vehicle determines the maximum power it can accept. If it supports only 7 kW, that\'s the maximum charging speed you\'ll get, even from a 22 kW charger.\n2. Ensure you\'re using a compatible charging cable with the correct connector for your EV. Some EV manufacturers provide this with the vehicle; otherwise, it may need to be purchased separately.\n3. Charging at 7 kW is slower than 22 kW, but it\'s still an effective option. For instance, a 7 kW charger can fully charge a 60 kWh battery in approximately 8 hours.\n\nAlways follow the safety instructions provided by the charging station operator and avoid using damaged cables. While a 22 kW charger offers higher speeds, a 7 kW station remains a reliable and efficient way to recharge your EV.',
      category: 'charging',
    ),
    FaqItem(
      question: 'What are Renergy\'s charging rates, and how does payment work?',
      answer:
          'Renergy\'s charging rates depend on the charger type and location. You can find specific pricing details in the app for each charging point.\n\nPayments are processed through our mobile app using a linked credit or debit card. Simply add your card details, start charging, and the billing amount will automatically be charged to your card once the session ends. It\'s a seamless, hassle-free process!',
      category: 'pricing',
    ),
  ];

  String searchQuery = '';
  String? category;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args['category'] is String) {
      category = (args['category'] as String).toLowerCase();
    }
  }

  void toggleExpanded(int index) {
    items[index].expanded = !items[index].expanded;
    update();
  }

  void updateSearchQuery(String value) {
    searchQuery = value;
    update();
  }

  List<FaqItem> get filteredItems {
    Iterable<FaqItem> list = items;
    if (category != null && category!.isNotEmpty) {
      list = list.where((i) => i.category == category);
    }
    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase();
      list = list.where((i) => i.question.toLowerCase().contains(q) || i.answer.toLowerCase().contains(q));
    }
    return list.toList();
  }
}