import 'package:flutter/material.dart';
import 'package:renergy_app/components/components.dart';

class ChargingScreenView extends StatelessWidget {
  const ChargingScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Charging'),
      ),
      body: const Center(
        child: Text('Charging Screen'),
      ),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: 1,
      ),
    );
  }
}
