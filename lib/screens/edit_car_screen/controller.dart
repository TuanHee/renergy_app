import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/models/car.dart';
import 'package:renergy_app/common/services/api_service.dart';

class EditCarController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final modelController = TextEditingController();
  final plateController = TextEditingController();

  bool isDefaultCar = false;
  bool isSaving = false;
  String? errorMessage;
  Car? car;

  @override
  void onInit() async {
    super.onInit();
    car = Get.arguments as Car;
    modelController.text = car?.model ?? '';
    plateController.text = car?.plate ?? '';
    isDefaultCar = car?.isDefault ?? false;
    update();
  }

  void toggleDefault(bool value) {
    isDefaultCar = value;
    update();
  }

  Future<void> updateCar({
    required String id,
  }) async {
    isSaving = true;
    update();
    try {
      final res = await Api().put(
        Endpoints.vehicle(int.parse(id)),
        data: {
           'model': modelController.text,
          'plate_number': plateController.text.toUpperCase(),
          'is_default': isDefaultCar ? 1 : 0,
        },
      );
      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to update car';
      }
    } catch (e) {
      rethrow;
    } finally {
      isSaving = false;
      update();
    }
  }

  Future<void> deleteCar() async {
    update();
    try {
      final res = await Api().delete(Endpoints.vehicle(car?.id ?? 0));
      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to delete car';
      }
    } catch (e) {
      update();
      rethrow;
    }
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

  @override
  void onClose() {
    modelController.dispose();
    plateController.dispose();
    super.onClose();
  }
}
