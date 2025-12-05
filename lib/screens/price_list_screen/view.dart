import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/models/fee_set.dart';
import 'controller.dart'; // Ensure this points to your controller

class PriceListScreenView extends StatelessWidget {
  const PriceListScreenView({Key? key}) : super(key: key);

  // Modern Color Palette
  static const Color primaryRed = Color(0xFFE53935);
  static const Color bgGrey = Color(0xFFF4F6F8);
  static const Color cardWhite = Colors.white;
  static const Color textDark = Color(0xFF212121);
  static const Color textLight = Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PriceListController>(
      init: PriceListController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: bgGrey,
          appBar: AppBar(
            backgroundColor: primaryRed,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            centerTitle: true,
            title: const Text(
              'Charging Process',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            children: [
              // Step 1: Minimum Charges
              _TimelineItem(
                isFirst: true,
                iconData: Icons.monetization_on_outlined,
                title: 'Minimum Charges',
                child: _buildInfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'A minimum fee applies when charging starts. If the total fee exceeds this amount, only the actual usage is charged.',
                        style: TextStyle(color: textLight, height: 1.4, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          const Text('RM', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textDark)),
                          const SizedBox(width: 4),
                          Text(_formatCurrency(controller.feeSet?.minimumChargeAmount), style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: primaryRed)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Step 2: Charging Fee
              _TimelineItem(
                iconData: Icons.flash_on_rounded,
                title: 'Charging Rates',
                child: _buildInfoCard(
                  padding: EdgeInsets.zero, // Custom padding for the list inside
                  child: Column(
                    children: [
                      // AC Section
                      _buildRateRow(
                        type: 'AC Charger',
                        color: Colors.blue.shade50,
                        textColor: Colors.blue.shade800,
                        details: _tierDetails(controller.feeSet?.tiersAc, controller.feeSet?.uomLabel),
                      ),
                      const Divider(height: 1),
                      // DC Section
                      _buildRateRow(
                        type: 'DC Charger',
                        color: Colors.orange.shade50,
                        textColor: Colors.orange.shade900,
                        details: _tierDetails(controller.feeSet?.tiersDc, controller.feeSet?.uomLabel),
                      ),
                    ],
                  ),
                ),
              ),

              // Step 3: Pricing (Idle Fee)
              _TimelineItem(
                iconData: Icons.timer_outlined,
                title: 'Idle Fees',
                child: _buildInfoCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Charged if vehicle remains parked 15 mins after charging ends.',
                        style: TextStyle(color: textLight, fontSize: 12),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.red.shade100),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Idle Penalty', style: TextStyle(fontWeight: FontWeight.w600, color: textDark, fontSize: 13)),
                            Text('RM ${_formatCurrency(controller.feeSet?.idleFeePrice)} / ${controller.feeSet?.idleFeeMinutesPerUnit ?? 0} min', style: TextStyle(fontWeight: FontWeight.bold, color: primaryRed, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Step 4: Completion
              _TimelineItem(
                isLast: true,
                iconData: Icons.check_circle,
                iconColor: Colors.green,
                title: 'Charging Complete',
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.green.shade400, Colors.green.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.thumb_up_alt_outlined, color: Colors.white, size: 24),
                          const SizedBox(height: 6),
                          const Text(
                            "You're all set!",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          
                        ],
                      ),
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Thank you for using ",
                            style: TextStyle(color: Colors.black, fontSize: 11),
                          ),
                          Image.asset('assets/icons/full_logo.png', color: Colors.red, width: 120, height: 60),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- Reusable Widgets ---

  Widget _buildInfoCard({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardWhite,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildRateRow({
    required String type,
    required Color color,
    required Color textColor,
    required List<Map<String, String>> details,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              type,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ),
          const SizedBox(height: 8),
          ...details.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item['kw']!, style: const TextStyle(fontWeight: FontWeight.w500, color: textDark, fontSize: 12)),
                Text(item['price']!, style: const TextStyle(fontWeight: FontWeight.w700, color: textDark, fontSize: 12)),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  String _formatCurrency(double? amount) {
    final v = amount ?? 0.0;
    return v.toStringAsFixed(2);
  }

  List<Map<String, String>> _tierDetails(List<dynamic>? tiers, String? uomLabel) {
    final uom = uomLabel ?? 'kWh';
    return (tiers ?? [])
        .map((t) => {
              'kw': '${(t.maxUsage ?? 0) ~/ 1000}kw & Below',
              'price': 'RM ${_formatCurrency(t.price)} / $uom',
            })
        .toList();
  }
}

class _TimelineItem extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Widget child;
  final bool isFirst;
  final bool isLast;
  final Color? iconColor;

  const _TimelineItem({
    Key? key,
    required this.iconData,
    required this.title,
    required this.child,
    this.isFirst = false,
    this.isLast = false,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line & Dot
          SizedBox(
            width: 30,
            child: Column(
              children: [
                // Top Line (invisible for first item, but keeps spacing)
                Expanded(
                  flex: 1,
                  child: isFirst ? const SizedBox() : Container(width: 2, color: Colors.grey.shade300),
                ),
                // The Dot/Icon
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: iconColor ?? PriceListScreenView.primaryRed, width: 1.5),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3, offset: const Offset(0, 1.5))
                    ],
                  ),
                  child: Icon(iconData, size: 12, color: iconColor ?? PriceListScreenView.primaryRed),
                ),
                // Bottom Line
                Expanded(
                  flex: 8,
                  child: isLast ? const SizedBox() : Container(width: 2, color: Colors.grey.shade300),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF424242),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  child,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}