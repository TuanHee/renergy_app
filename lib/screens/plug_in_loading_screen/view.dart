import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import '../../components/main_bottom_nav_bar.dart';
import '../../components/snackbar.dart';
import 'controller.dart';

class PlugInLoadingScreenView extends StatefulWidget {
  const PlugInLoadingScreenView({Key? key}) : super(key: key);

  @override
  State<PlugInLoadingScreenView> createState() => _PlugInLoadingScreenState();
}

class _PlugInLoadingScreenState extends State<PlugInLoadingScreenView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPlugStatus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _fetchPlugStatus()async {
    try {
      await Get.find<PlugInLoadingController>().pollPlugStatus(context);
    } catch (e) {
      Snackbar.showError('Charging session stopped Error: $e', context);
    }
  }

  void _stopPending() {
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
            onPressed: () {
              Navigator.pop(context);
              try {
                Get.find<PlugInLoadingController>().cancelPending();
                Snackbar.showSuccess('Charging session stopped', context);
                Get.offAllNamed(AppRoutes.charging);
              } catch (e) {
                Snackbar.showError(
                  'Charging session stopped Error: $e',
                  context,
                );
              }
            },
            child: const Text('Stop', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlugInLoadingController>();
    return Scaffold(
      bottomNavigationBar: const MainBottomNavBar(currentIndex: 1),
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Icon
                SizedBox(
                  height: 160,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 16),
                      Icon(Icons.power, size: 48, color: Colors.green[300]),

                      AnimatedBuilder(
                        animation: _pulseAnimation,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _pulseAnimation.value,
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              width: 80,
                              height: 2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.green[300]!,
                                    Colors.green[500]!,
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      Icon(
                        Icons.directions_car,
                        size: 48,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),

                // Title
                const Text(
                  'Ready to Charge',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Please connect the port to your vehicle within 15 minutes.\nIdle fees might apply after grace period.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),

                // Status Indicator
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Opacity(
                          opacity: _pulseAnimation.value,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF5350), // red-500
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Waiting for connection',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Charger Info Card
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB), // gray-50
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              'Charger ID',
                              controller.order?.chargerId != null
                                  ? controller.order!.chargerId.toString()
                                  : '-',
                            ),
                          ),
                          Expanded(
                            child: _buildInfoItem(
                              'Station',
                              '${controller.order?.station?.name ?? 'N/A'}',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoItem(
                              'Power Output',
                              '${controller.order?.bay?.port?.outputPower ?? 0} kW',
                            ),
                          ),
                          Expanded(
                            child: _buildInfoItem(
                              'Type',
                              '${controller.order?.bay?.port?.portType ?? 0}',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Waiting Time
                GetBuilder<PlugInLoadingController>(
                  builder: (controller) => Text(
                    '${controller.remainSecond <= 0 ? 'Idle Time' : 'Remaining Time'}: ${controller.secondToMinute(controller.remainSecond.abs())}${controller.remainSecond <= 0 ? ' (RM 1 per 5 Minute)' : ''}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 4),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _stopPending(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      side: BorderSide(color: Colors.grey.shade600),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // Help Text
                Text(
                  'Having trouble? Contact support',
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
        const SizedBox(height: 4),
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
