import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/components/components.dart';
import 'package:renergy_app/main_controller.dart';
import 'package:renergy_app/screens/screens.dart';

class ChargingScreenView extends StatefulWidget {
  const ChargingScreenView({super.key});

  @override
  State<ChargingScreenView> createState() => _ChargingScreenViewState();
}

class _ChargingScreenViewState extends State<ChargingScreenView> {
  void _fetchIsCharging() async {
    final mainController = Get.find<MainController>();
    try {
      await mainController.fetchChargingOrder();
      if (mainController.chargingOrder?.status != null) {
        switch (ChargingStatsStatus.fromString(
          mainController.chargingOrder!.status,
        )) {
          case ChargingStatsStatus.open:
            Get.toNamed(AppRoutes.plugInLoading);
            break;

          case ChargingStatsStatus.accepted:
            Get.toNamed(AppRoutes.plugInLoading);
            break;

          case ChargingStatsStatus.charging:
            Get.toNamed(AppRoutes.chargeProcessing);
            break;

          case ChargingStatsStatus.completed:
            Get.toNamed(AppRoutes.recharge);
            break;
          default:
            break;
        }
      }
    } catch (e) {
      if (mounted) {
        Snackbar.showError(e.toString(), context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchIsCharging();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Charging Session'), centerTitle: true),
      body: GetBuilder<ChargingController>(
        builder: (controller) {
          return Center(
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
                      // Get.offAllNamed(AppRoutes.explorer);
                      Get.offAllNamed(AppRoutes.paymentResult);
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
          );
        },
      ),
      bottomNavigationBar: const MainBottomNavBar(currentIndex: 1),
    );
  }
}
