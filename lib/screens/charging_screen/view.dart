import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/components/components.dart';
import 'package:renergy_app/screens/screens.dart';

class ChargingScreenView extends StatelessWidget {
  const ChargingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Charging Session',
        ),
        centerTitle: true,
      ),
      body: GetBuilder<ChargingController>  (
        builder: (controller) {
          if (controller.status == ChargingStatus.pending && controller.order != null) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(32),
                    color: Colors.white,
                    child: const Icon(
                        Icons.ev_station,
                        size: 120,
                        color: Colors.grey,
                      ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300), 
                    child: Text(
                      controller.pendingIdleTime,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    )
                  ),
                  const SizedBox(height: 16),
                  Center(child: Column(
                    children: [
                      Text('Please connect the port to your vehicle within 15 minutes.\nIdle fees might apply after grace period.', 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center,),
                    ],
                  )),
                  const SizedBox(height: 16),
                  OutlinedButton(onPressed: controller.cancelPending, child: const Text('Cancel')),
                ],
              ),
            );

          } else if (controller.status == ChargingStatus.charging || controller.status == ChargingStatus.completed && controller.order != null) {
            int usage = controller.chargingStats?.meter?.usage != null ? (controller.chargingStats!.meter!.usage!) : 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Illustration section
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(controller.status.value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
                        const Icon(
                          Icons.ev_station,
                          size: 120,
                          color: Colors.grey,
                        ),
                        Text(
                          'Usage: ${usage > 1000 ? '${(usage / 1000)} kWh' : '$usage Wh'}', 
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ),
                ),
                
                // Charging details section (styled as bottom sheet)
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 12,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 32,
                          height: 4,
                          margin: const EdgeInsets.only(top: 12, bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      // Charging details
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildDetailRow(Icons.ev_station, 'Charging Bay', controller.order!.bay!.name!),
                            const Divider(height: 32),
                            _buildDetailRow(Icons.power, 'Port Type', controller.order!.bay!.port!.portType!),
                            const Divider(height: 32),
                            _buildDetailRow(Icons.bolt, 'Output Power (kW)', '${controller.order!.bay!.port!.outputPower} kW'),
                            const Divider(height: 32),
                            _buildDetailRow(Icons.attach_money, 'Cost (RM)', '0.99 / h'),
                            const Divider(height: 32),
                            _buildDetailRow(Icons.battery_std, 'Battery (%)', controller.chargingStats?.meter?.soc != null ? '${controller.chargingStats!.meter!.soc}%' : '-'),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Total Amount', style: TextStyle(fontSize: 12),),
                                Text('RM ${controller.chargingStats!.meter?.usage != null ? '${((controller.chargingStats!.meter!.usage! / 1000) * 0.99).toStringAsFixed(2)}' : '-'}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
                              ],
                            ),
                            if (controller.status == ChargingStatus.charging) ...[
                              OutlinedButton(
                                onPressed: controller.stopCharging, 
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                                child: const Text('End Charging'), 
                              ),
                            ],
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }

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
                              color: Colors.black,
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
          );
        }
      ),
      bottomNavigationBar: const MainBottomNavBar(
        currentIndex: 1,
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.grey.shade700),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
