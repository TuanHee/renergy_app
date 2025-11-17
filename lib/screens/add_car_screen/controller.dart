import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddCarController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final modelController = TextEditingController();
  final plateController = TextEditingController();

  bool isDefaultCar = false;
  bool isSaving = false;
  String? errorMessage;

  void toggleDefault(bool value) {
    isDefaultCar = value;
    update();
  }

  String? validateModel(String? value) {
    if (value == null || value.trim().isEmpty) return null; // optional
    if (value.trim().length < 2) return 'Enter a valid car model';
    return null;
  }

  String? validatePlate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Car plate number is required';
    }
    final v = value.trim().toUpperCase();
    // Basic MY-style plate: 1-3 letters + optional space + 1-4 alphanumerics
    final pattern = RegExp(r'^[A-Z]{1,3}\s?[A-Z0-9]{1,4}$');
    if (!pattern.hasMatch(v)) {
      return 'Use format e.g. ABC123 or ABC 123';
    }
    return null;
  }

  Future<void> save() async {
    final currentState = formKey.currentState;
    if (currentState == null) return;
    if (!currentState.validate()) return;

    isSaving = true;
    errorMessage = null;
    update();

    try {
      // TODO: Integrate with actual save service/API
      await Future.delayed(const Duration(milliseconds: 600));
      print('Saving car: ${modelController.text}, ${plateController.text}');

      Get.snackbar(
        'Saved',
        'Your car has been added',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      Get.back();
    } catch (e) {
      errorMessage = 'Failed to save. Please try again.';
      Get.snackbar(
        'Error',
        errorMessage!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade600,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isSaving = false;
      update();
    }
  }

  @override
  void onClose() {
    modelController.dispose();
    plateController.dispose();
    super.onClose();
  }
}