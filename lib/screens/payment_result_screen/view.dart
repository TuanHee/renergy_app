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
        final moneyKeys = {
          'Subtotal',
          'Discount (%)',
          'Discount Amount',
          'Tax (%)',
          'Tax Amount',
          'Net Amount',
          'Amount',
        };
        final moneyItems = controller.items
            .where((e) => moneyKeys.contains(e['label']))
            .toList();
        final otherItems = controller.items
            .where((e) => !moneyKeys.contains(e['label']))
            .toList();
        final completedRaw = controller.order?.completedAt;
        String completedText = '';
        if (completedRaw != null && completedRaw.isNotEmpty) {
          final dt = DateTime.tryParse(completedRaw);
          if (dt != null) {
            final local = dt.toLocal();
            const months = [
              'Jan',
              'Feb',
              'Mar',
              'Apr',
              'May',
              'Jun',
              'Jul',
              'Aug',
              'Sep',
              'Oct',
              'Nov',
              'Dec',
            ];
            final h = local.hour;
            final ampm = h >= 12 ? 'PM' : 'AM';
            final hh = ((h % 12 == 0 ? 12 : h % 12)).toString().padLeft(2, '0');
            final mm = local.minute.toString().padLeft(2, '0');
            completedText =
                '${local.day.toString().padLeft(2, '0')} ${months[local.month - 1]} ${local.year}, $hh:$mm $ampm';
          } else {
            completedText = completedRaw;
          }
        }
        return Scaffold(
          backgroundColor: const Color(0xFFF3F6FA),
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Payment Result'),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
            actions: [
              IconButton(
                onPressed: () => controller.downloadInvoice(),
                icon: controller.isDownloading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download, color: Colors.white),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     CircleAvatar(
                  //       radius: 18,
                  //       backgroundColor: Colors.green.shade100,
                  //       child: Icon(Icons.check, color: Colors.green.shade700),
                  //     ),
                  //   ],
                  // ),
                  const SizedBox(height: 12),
                  Text(
                    controller.order!.invoiceNo ?? '',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    completedText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: muted,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Divider(color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Payment Summary',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...moneyItems.map((e) {
                          final label = e['label'] ?? '';
                          final value = e['value'] ?? '';
                          final isTotal =
                              label == 'Net Amount' || label == 'Amount';
                          return _buildKeyValueRow(
                            label,
                            value,
                            highlightValue: isTotal,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Details',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...otherItems.map((e) {
                          final label = e['label'] ?? '';
                          final value = e['value'] ?? '';
                          return _buildKeyValueRow(label, value);
                        }).toList(),
                      ],
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

Widget _buildKeyValueRow(
  String label,
  String value, {
  bool highlightValue = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(color: Colors.black54)),
        ),
        Text(
          value,
          style: TextStyle(
            color: highlightValue ? const Color(0xFFD32F2F) : Colors.black87,
            fontWeight: highlightValue ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ],
    ),
  );
}
