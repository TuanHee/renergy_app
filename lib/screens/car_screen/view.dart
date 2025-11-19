import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/components/snackbar.dart';

import 'controller.dart';
import 'widget/car_widget.dart';

// Main Card Storage Page
class CarScreenView extends StatefulWidget {
  const CarScreenView({Key? key}) : super(key: key);

  @override
  State<CarScreenView> createState() => _CarScreenViewState();
}

class _CarScreenViewState extends State<CarScreenView> {

  @override
  void initState() {
    super.initState();
    _fetchCar();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _fetchCar(); // Refresh when returning
    }
  }

  void _fetchCar(){
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      try {
        await Get.find<CarController>().fetchCarIndex();
      } catch (e) {
        Snackbar.showError(e.toString(), context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CarController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            title: const Text(
              'My Cars',
            ),
            centerTitle: true,
          ),
          body: controller.cars.isEmpty
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
                            Icons.electric_car,
                            size: 120,
                            color: Colors.grey,
                          ),
                          // Map pin with X overlay on bottom right
                        ],
                      ),
                      const SizedBox(height: 48),
        
                      const Text(
                        'No cars added yet',
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
                        'Tap + to add your first car',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.cars.length,
                  itemBuilder: (context, index) {
                    return CarWidget(
                      car: controller.cars[index],
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: controller.toAddCarPage,
            backgroundColor: Color(0xFFD32F2F),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      }
    );
  }
}

// Card Widget to display individual cards
