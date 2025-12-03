import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/components/snackbar.dart';

import '../../components/main_bottom_nav_bar.dart';
import 'controller.dart';

// Recharge Page asking user to leave or start a new session
class RechargeScreenView extends StatefulWidget {
  const RechargeScreenView({super.key});

  @override
  State<RechargeScreenView> createState() => _RechargeScreenViewState();
}

class _RechargeScreenViewState extends State<RechargeScreenView> {
  void _startRecharge(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ReCharge?'),
        content: const Text(
          'Are you sure you want to restart the charging session?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await Get.find<RechargeController>().recharge();
                Get.back();
              } catch (e) {
                Snackbar.showError(e.toString(), context);
              }
            },
            child: const Text('recharge', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<RechargeController>().pollChargingStatus();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Charging Completed'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAllNamed(AppRoutes.charging, arguments: {'isStayPage': true}),
        ),
      ),
      bottomNavigationBar: const MainBottomNavBar(currentIndex: 1),
      body: GetBuilder<RechargeController>(
        builder: (controller) => Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              decoration: BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Illustration
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      color: Color(0xFF2E7D32),
                      size: 96,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your charging session has finished',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Please leave the parking spot so others can charge. Or start a new session if you need more energy.',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
        
                  if(controller.remainSecond != null)
                  GetBuilder<RechargeController>(
                    builder: (controller) => Text(
                      '${controller.remainSecond! <= 0 ? 'Idle Time' : 'Remaining Time'}: ${controller.secondToMinute(controller.remainSecond!.abs())}${controller.remainSecond! <= 0 ? ' (RM 1 per 5 Minute)' : ''}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ),
        
                  const SizedBox(height: 4),
                  if(controller.canRecharge)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _startRecharge(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD32F2F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Recharge'),
                    ),
                  ),
        
                  const SizedBox(height: 4),
                  TextButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.getHelp);
                  },
                  child: Text(
                    'Having trouble? Contact support',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
