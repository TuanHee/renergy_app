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
            title: const Text('Completed'),
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
                  // Header image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: (controller.order?.station?.mainImageUrl != null
                        ? Image.network(
                            controller.order!.station!.mainImageUrl!,
                            height: 180,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            'assets/images/image_placeholder.png',
                            height: 180,
                            fit: BoxFit.cover,
                          )),
                  ),

                  const SizedBox(height: 12),

                  // Reference ID and date row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Reference ID ',
                            style: TextStyle(
                              color: muted,
                              fontSize: 14
                            ),
                          ),
                          Text(
                            controller.order?.id?.toString().padLeft(4, '0') ?? '',
                            style: TextStyle(
                              color:Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14
                            ),
                          ),
                        ],
                      ),
                      Text(
                        (() {
                          final raw = controller.order?.createdAt;
                          if (raw == null || raw.isEmpty) return '-';
                          final dt = DateTime.tryParse(raw);
                          if (dt == null) return raw;
                          final local = dt.toLocal();
                          const monthsFull = [
                            'January',
                            'February',
                            'March',
                            'April',
                            'May',
                            'June',
                            'July',
                            'August',
                            'September',
                            'October',
                            'November',
                            'December',
                          ];
                          final day = local.day.toString().padLeft(2, '0');
                          final monthName = monthsFull[local.month - 1];
                          final year = local.year.toString();
                          final hh = local.hour.toString().padLeft(2, '0');
                          final mm = local.minute.toString().padLeft(2, '0');
                          return '$day $monthName $year, $hh:$mm';
                        })(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 13
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  _dashedDivider(),

                  const SizedBox(height: 12),

                  // Station name and bay chip
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          controller.order?.stationName ?? controller.order?.station?.name ?? '-',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if ((controller.order?.bay?.name ?? '').isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            controller.order!.bay!.name!,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          controller.order?.bayName ?? '-',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  _dashedDivider(),

                  const SizedBox(height: 12),

                  // Details section mimicking the screenshot
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
                        _buildKeyValueRow('Port Type', controller.order?.port?.portType ?? '-'),
                        _buildKeyValueRow('Port Voltage', controller.order?.port?.outputPower ?? '-'),
                        _buildKeyValueRow(
                          'Total kWh Usage',
                          '${((controller.order?.totalUsage ?? 0) / 1000).toStringAsFixed(1)} kWh',
                        ),
                        _buildKeyValueRow(
                          'Duration',
                          (() {
                            final m = (controller.order?.totalChargingTimeMinutes ?? 0).toInt();
                            final hh = (m ~/ 60).toString().padLeft(2, '0');
                            final mm = (m % 60).toString().padLeft(2, '0');
                            return '$hh:$mm:00';
                          })(),
                        ),
                        const SizedBox(height: 8),
                        _dashedDivider(),
                        const SizedBox(height: 8),
                        _buildKeyValueRow('Payment Method', '-'),
                        _buildKeyValueRow(
                          'Charging Fee',
                          controller.order?.charging_price == null
                              ? '-'
                              : 'RM${controller.order!.charging_price!.toStringAsFixed(2)}',
                        ),
                        _buildKeyValueRow(
                          'Subtotal',
                          controller.order?.subtotalAmount == null
                              ? '-'
                              : 'RM${controller.order!.subtotalAmount!.toStringAsFixed(2)}',
                        ),
                        _buildKeyValueRow(
                          'Discount',
                          controller.order?.discountAmount != null
                              ? 'RM${controller.order!.discountAmount!.toStringAsFixed(2)}'
                              : (controller.order?.discountPercentage != null
                                  ? '${controller.order!.discountPercentage!.toStringAsFixed(2)}%'
                                  : '-'),
                        ),
                        _buildKeyValueRow(
                          'Total Paid',
                          controller.order?.netAmount == null
                              ? '-'
                              : 'RM${controller.order!.netAmount!.toStringAsFixed(2)}',
                          highlightValue: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Action button
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      side: BorderSide(color: Colors.grey.shade700),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'See Less Details',
                      style: TextStyle(fontWeight: FontWeight.w600),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: highlightValue ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

// New dashed divider helper used in the redesigned layout
Widget _dashedDivider({
  Color? color,
  double dashWidth = 6,
  double dashSpace = 4,
  double height = 1,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final effectiveColor = color ?? Colors.grey.shade300;
      final dashCount = (constraints.maxWidth / (dashWidth + dashSpace)).floor();
      return Row(
        children: List.generate(dashCount, (index) {
          return Padding(
            padding: EdgeInsets.only(right: index == dashCount - 1 ? 0 : dashSpace),
            child: Container(
              width: dashWidth,
              height: height,
              color: effectiveColor,
            ),
          );
        }),
      );
    },
  );
}
