import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';

class PaymentResultScreenView extends StatelessWidget {
  const PaymentResultScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PaymentResultController>(
      builder: (controller) {
        final red = const Color(0xFFD32F2F);
        final muted = Colors.grey.shade600;
        final moneyKeys = {'Subtotal', 'Discount (%)', 'Discount Amount', 'Tax (%)', 'Tax Amount', 'Net Amount', 'Amount'};
        final moneyItems = controller.items.where((e) => moneyKeys.contains(e['k'])).toList();
        final otherItems = controller.items.where((e) => !moneyKeys.contains(e['k'])).toList();
        return Scaffold(
          backgroundColor: const Color(0xFFF3F6FA),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.green.shade100,
                        child: Icon(Icons.check, color: Colors.green.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Payment Success!', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(controller.amountText, textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: red)),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Payment Summary', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        ...moneyItems.map((e) => _kv(e['k'] ?? '', e['v'] ?? '')).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text('Details', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        ...otherItems.map((e) => _kv(e['k'] ?? '', e['v'] ?? '')).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => controller.goToCharging(),
                      child: const Text('Back to Charging'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _kv(String k, String v) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(child: Text(k, style: const TextStyle(color: Colors.black54))),
        Text(v, style: const TextStyle(color: Colors.black87)),
      ],
    ),
  );
}