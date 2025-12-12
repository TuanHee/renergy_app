import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/common/constants/endpoints.dart';

class PhoneVerificationController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final tacController = TextEditingController();

  bool isRequestingTac = false;
  bool isSaving = false;
  bool codeRequested = false;
  int requestCooldown = 0; // seconds
  Timer? _cooldownTimer;

  String? errorMessage;
  String? infoMessage;

  String? validatePhone(String? v) {
    final val = v?.trim() ?? '';
    if (val.isEmpty) return 'Please enter phone number';
    final digits = val.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 8 || digits.length > 10) return 'Invalid phone number';
    return null;
  }

  String? validateTac(String? v) {
    final val = v?.trim() ?? '';
    if (val.isEmpty) return 'Please enter TAC';
    if (val.length < 4) return 'TAC must be at least 4 digits';
    return null;
  }

  bool get canRequestTac => !isRequestingTac && requestCooldown == 0;
  bool get canSave => !isSaving && (formKey.currentState?.validate() ?? false) && tacController.text.trim().length >= 4;

  Future<void> requestTac() async {
    final validPhone = validatePhone(phoneController.text) == null;
    if (!validPhone) {
      infoMessage = null;
      errorMessage = 'Please enter a valid phone number';
      update();
      return;
    }
    isRequestingTac = true;
    errorMessage = null;
    infoMessage = null;
    update();
    try {
      final phone = '0' + phoneController.text.trim();
      await Api().post(Endpoints.sendOtp, data: {
        'phone': phone,
        'requestTac': true,
      });
      codeRequested = true;
      infoMessage = 'A TAC has been sent to $phone';
      _startCooldown(60);
    } catch (e) {
      codeRequested = true;
      _startCooldown(60);
    } finally {
      isRequestingTac = false;
      update();
    }
  }

  void _startCooldown(int seconds) {
    requestCooldown = seconds;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      requestCooldown = requestCooldown - 1;
      if (requestCooldown <= 0) {
        t.cancel();
        requestCooldown = 0;
      }
      update();
    });
    update();
  }

  Future<void> save() async {
    final valid = formKey.currentState?.validate() ?? false;
    if (!valid) return;
    isSaving = true;
    errorMessage = null;
    infoMessage = null;
    update();
    try {
      final phone = '0' + phoneController.text.trim();
      final tac = tacController.text.trim();
    print('save start1');

      await Api().post(Endpoints.updatePhoneNumber, data: {
        'phone': phone,
        'tac': tac,
      });
    print('save start2');

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
    phoneController.dispose();
    tacController.dispose();
    _cooldownTimer?.cancel();
    super.onClose();
  }
}