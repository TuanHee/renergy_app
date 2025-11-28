import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/components/main_bottom_nav_bar.dart';
import '../../components/snackbar.dart';
import 'controller.dart';

class ChargeProcessingScreenView extends StatefulWidget {
  const ChargeProcessingScreenView({Key? key}) : super(key: key);

  @override
  State<ChargeProcessingScreenView> createState() =>
      _ChargeProcessingScreenState();
}

class _ChargeProcessingScreenState extends State<ChargeProcessingScreenView>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for charging indicator
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<ChargeProcessingController>().pollChargingStatus();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _stopCharging() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop Charging?'),
        content: const Text(
          'Are you sure you want to stop the charging session?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Get.find<ChargeProcessingController>().stopCharging();
                Snackbar.showSuccess('Charging session stopped', context);
              } catch (e) {
                Snackbar.showError(e.toString(), context);
              }
              Navigator.pop(context);
            },
            child: const Text('Stop', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(currentIndex: 1),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color.fromARGB(255, 233, 231, 231), // red-50
              Color(0xFFFFF7ED), // orange-50
            ],
          ),
        ),
        child: SafeArea(
          child: GetBuilder<ChargeProcessingController>(
            builder: (controller) => Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Get.offAllNamed(
                          AppRoutes.charging,
                          arguments: {'isStayPage': true},
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'Charging',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // balance the row
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // Battery Level Display
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Pulsing background
                            AnimatedBuilder(
                              animation: _pulseAnimation,
                              builder: (context, child) {
                                return Opacity(
                                  opacity: _pulseAnimation.value * 0.3,
                                  child: Container(
                                    width: 200,
                                    height: 200,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(
                                        255,
                                        53,
                                        220,
                                        38,
                                      ), // red-600
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                );
                              },
                            ),

                            // Main circle
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Progress indicator
                                  SizedBox(
                                    width: 160,
                                    height: 160,
                                    child: CircularProgressIndicator(
                                      value:
                                          (controller
                                                  .chargingStats
                                                  ?.meter
                                                  ?.soc ??
                                              0) /
                                          100.0,
                                      strokeWidth: 8,
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        226,
                                        254,
                                        226,
                                      ),
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                            Color.fromARGB(
                                              255,
                                              82,
                                              240,
                                              34,
                                            ), // red-600
                                          ),
                                    ),
                                  ),

                                  // Battery percentage
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        controller.chargingStats?.meter?.soc ==
                                                null
                                            ? '-'
                                            : '${controller.chargingStats!.meter!.soc!.toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          fontSize: 42,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1F2937),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      AnimatedBuilder(
                                        animation: _pulseAnimation,
                                        builder: (context, child) {
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.bolt,
                                                size: 16,
                                                color: Color.lerp(
                                                  const Color.fromARGB(
                                                    255,
                                                    40,
                                                    230,
                                                    56,
                                                  ),
                                                  const Color.fromARGB(
                                                    255,
                                                    68,
                                                    239,
                                                    82,
                                                  ),
                                                  _pulseAnimation.value,
                                                ),
                                              ),
                                              const SizedBox(width: 4),
                                              const Text(
                                                'Charging',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFF6B7280),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        // Charging Stats Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.speed,
                                label: 'Port Type',
                                value:
                                    controller
                                        .chargingStats
                                        ?.order
                                        ?.bay
                                        ?.port
                                        ?.portType ??
                                    '-',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.access_time,
                                label: 'Output Power (kW)',
                                value:
                                    '${controller.chargingStats?.order?.bay?.port?.outputPower ?? 0} kW',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.battery_charging_full,
                                label: 'Energy Added',
                                value:
                                    '${((controller.chargingStats?.meter?.usage ?? 0) / 1000).toStringAsFixed(1)} kWh',
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                icon: Icons.attach_money,
                                label: 'Current Cost',
                                value:
                                    'RM ${controller.chargingStats?.meter?.usage != null && controller.chargingStats!.order!.charging_price != null ? ((controller.chargingStats!.meter!.usage! / 1000) * controller.chargingStats!.order!.charging_price!).toStringAsFixed(2) : '-'}',
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Session Details
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Session Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildDetailRow(
                                'Charger ID',
                                controller.chargingStats?.order?.chargerId !=
                                        null
                                    ? controller
                                          .chargingStats!
                                          .order!
                                          .chargerId!
                                          .toString()
                                    : '-',
                              ),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                'Location',
                                controller
                                        .chargingStats
                                        ?.order
                                        ?.station
                                        ?.name ??
                                    '-',
                              ),
                              const SizedBox(height: 12),
                              _buildDetailRow(
                                'Start Time',
                                controller.chargingStats?.startAt != null
                                    ? DateTime.parse(
                                        controller.chargingStats!.startAt!,
                                      ).toLocal().toString().substring(0, 16)
                                    : '-',
                              ),

                              const SizedBox(height: 12),
                              _buildDetailRow(
                                'Rate (RM)',
                                '${controller.chargingStats!.order!.charging_price!.toStringAsFixed(2)}/kWh',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Stop Charging Button
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _stopCharging,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFDC2626),
                              side: const BorderSide(
                                color: Color(0xFFDC2626),
                                width: 2,
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Stop Charging',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 24,
            color: const Color(0xFFDC2626), // red-600
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }
}
