import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/models/customer.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import '../account_screen/controller.dart';

class EditProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool isSaving = false;
  String? errorMessage;
  Customer? customer;

  @override
  void onInit() {
    super.onInit();
    if (Get.isRegistered<AccountController>()) {
      customer = Get.find<AccountController>().customer;
    }
    _fillFromCustomer();
  }

  void _fillFromCustomer() {
    nameController.text = customer?.name ?? '';
    phoneController.text = customer?.phone != null && customer!.phone!.isNotEmpty
        ? customer!.phone!.substring(1, customer!.phone!.length)
        : '';
    emailController.text = customer?.email ?? '';
  }

  String? validateName(String? v) {
    final val = v?.trim() ?? '';
    if (val.isEmpty) return 'Please enter your name';
    return null;
  }

  String? validatePhone(String? v) {
    final val = v?.trim() ?? '';
    if (val.isEmpty) return 'Please enter phone number';
    final digits = val.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8 || digits.length > 10) return 'Invalid phone number';
    return null;
  }

  String? validateEmail(String? v) {
    final val = v?.trim() ?? '';
    if (val.isEmpty) return null;
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(val);
    if (!ok) return 'Invalid email';
    return null;
  }

  Future<void> save() async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return;
    isSaving = true;
    errorMessage = null;
    update();
    try {
      final data = {
        'name': nameController.text.trim(),
        'phone': '0'+ phoneController.text.trim(),
      };
      await Api().post(Endpoints.updateProfile, data: data);
      if (Get.isRegistered<AccountController>()) {
        await Get.find<AccountController>().fetchAccountDetails();
      }
      Get.back(result: true);
    } catch (e) {
      errorMessage = e.toString();
      update();
    } finally {
      isSaving = false;
      update();
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.onClose();
  }
}