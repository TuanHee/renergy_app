import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/components/components.dart';
import 'package:renergy_app/screens/screens.dart';

class ChargingScreenView extends StatefulWidget {
  const ChargingScreenView({super.key});

  @override
  State<ChargingScreenView> createState() => _ChargingScreenViewState();
}

class _ChargingScreenViewState extends State<ChargingScreenView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final isStayPage = Get.arguments?['isStayPage'] ?? false;
      await Future.wait([
        Get.find<ChargingController>().fetchChargingHistory(),
        Get.find<ChargingController>().fetchChargingOrder(),
      ]);
      if (!isStayPage) {
        navToSpecificPage();
      }
    });
  }

  void navToSpecificPage() {
    if (!Get.isRegistered<ChargingController>()) {
      return;
    }
    final controller = Get.find<ChargingController>();
    print('Charging status: ${controller.status}');
    try {
      switch (controller.status) {
        case ChargingStatsStatus.open:
          Get.toNamed(
            AppRoutes.plugInLoading,
            arguments: controller.currentOrder,
          );
          break;

        case ChargingStatsStatus.pending:
          Get.toNamed(
            AppRoutes.plugInLoading,
            arguments: controller.currentOrder,
          );
          break;

        case ChargingStatsStatus.charging:
          Get.toNamed(
            AppRoutes.chargeProcessing,
            arguments: controller.currentOrder,
          );
          break;

        case ChargingStatsStatus.finishing:
          Get.toNamed(AppRoutes.recharge, arguments: controller.currentOrder);

        case ChargingStatsStatus.restarting:
          Get.toNamed(
            AppRoutes.plugInLoading,
            arguments: controller.currentOrder,
          );
          break;

        // case ChargingStatsStatus.paymentPending:
        //   Get.toNamed(AppRoutes.charging);
        //   break;

        // case ChargingStatsStatus.unPaid:
        //   Get.toNamed(AppRoutes.paymentResult);
        //   break;

        case ChargingStatsStatus.completed:
          Get.toNamed(AppRoutes.paymentResult);
          break;
        default:
          break;
      }
    } catch (e) {
      if (mounted) {
        Snackbar.showError(e.toString(), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 245, 251),
      appBar: AppBar(title: const Text('Charging History'), centerTitle: true),
      body: GetBuilder<ChargingController>(
        builder: (controller) {
          return controller.orderHistories.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration with charging station icon
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Light gray circle background
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                            ),
                            // Charging station icon
                            const Icon(
                              Icons.ev_station,
                              size: 120,
                              color: Colors.grey,
                            ),
                            // Map pin with X overlay on bottom right
                            Positioned(
                              bottom: 10,
                              right: 10,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    size: 32,
                                    color: Color.fromRGBO(0, 0, 0, 1),
                                  ),
                                  const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),
                        // "No charging session yet" heading
                        const Text(
                          'No charging session yet',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // Explanatory text
                        Text(
                          'Let\'s search a charging station that suits you and charge via Recharge now.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        // Explore Now button
                        OutlinedButton(
                          onPressed: () {
                            Get.offAllNamed(AppRoutes.explorer);
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 16,
                            ),
                            side: BorderSide(color: Colors.grey.shade800),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Explore Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.orderHistories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = controller.orderHistories[index];
                    final amount = order.netAmount == null
                        ? '-'
                        : 'RM${order.netAmount!.toStringAsFixed(2)}';
                    final totalUsage = order.totalUsage == null
                        ? '-'
                        : '${order.totalUsage} kWh';
                    final location =
                        [
                              order.station?.address1,
                              order.station?.address2,
                              order.station?.state,
                            ]
                            .where((e) => e != null && e.toString().isNotEmpty)
                            .join(', ');
                    final status = order.status ?? '';
                    // Compute total charging duration in minutes
                    final duration = order.totalChargingTimeMinutes != null
                        ? order.totalChargingTimeMinutes!.toInt()
                        : 0;
                    final durationText = duration > 0 ? '${duration} min' : '-';
                    final rawDate = order.completedAt ?? order.createdAt;
                    String date = '-';
                    if (rawDate != null && rawDate.isNotEmpty) {
                      final dt = DateTime.tryParse(rawDate);
                      if (dt != null) {
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
                        date =
                            '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
                      } else {
                        date = rawDate;
                      }
                    }
                    final statusColor = status == 'Completed'
                        ? Colors.green.shade600
                        : status == 'Charging'
                        ? Colors.blue.shade600
                        : status == 'Pending' || status == 'Open'
                        ? Colors.orange.shade600
                        : Colors.grey.shade600;
                    final title = order.station?.name ?? 'Station';
                    final carPlate =
                        order.customer?.customerVehiclePlate ?? '-';
                    return Card(
                      color: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Get.toNamed(
                          AppRoutes.paymentResult,
                          arguments: order,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  // Text(
                                  //   amount,
                                  //   style: const TextStyle(fontWeight: FontWeight.w700),
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          amount,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFFD32F2F),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.chevron_right,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Divider(
                                color: Colors.grey.shade300,
                                height: 8,
                                thickness: 3,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    date,
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: statusColor.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),
                              _kv('Port', order.bay?.port?.portType ?? '-'),
                              const SizedBox(height: 6),
                              _kv('Car Plate', carPlate),
                              const SizedBox(height: 6),
                              _kv('Usage', '$totalUsage in $durationText'),

                              const SizedBox(height: 6),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      bottomNavigationBar: const MainBottomNavBar(currentIndex: 1),
    );
  }
}

Widget _kv(String k, String v) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Expanded(
          child: Text(k, style: const TextStyle(color: Colors.black54)),
        ),
        Text(v, style: const TextStyle(color: Colors.black87)),
      ],
    ),
  );
}
