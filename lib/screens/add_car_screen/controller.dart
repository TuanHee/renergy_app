import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/services/api_service.dart';

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

  Future<void> addCar() async {
    isSaving = true;
    update();
    try {
      final data ={
          'model': modelController.text,
          'plate_number': plateController.text.toUpperCase(),
          'is_default': isDefaultCar ? 1 : 0,
        };
      final res = await Api().post(
        Endpoints.vehicles,
        data: data,
      );
      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to add car';
      }
    } catch (e) {
      rethrow;
    } finally {
      isSaving = false;
      update();
    }
  }

  Future<void> updateCar({
    required String id,
    String? model,
    String? plate,
    bool? isDefault,
  }) async {
    isSaving = true;
    update();
    try {
      final res = await Api().put(
        Endpoints.vehicle(int.parse(id)),
        data: {
          if (model != null) 'model': model,
          if (plate != null) 'plate': plate.toUpperCase(),
          if (isDefault != null) 'is_default': isDefault,
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
