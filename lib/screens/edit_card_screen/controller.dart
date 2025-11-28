import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/models/credit_card.dart';
import 'package:renergy_app/common/services/api_service.dart';

class EditCardController extends GetxController {
  final formKey = GlobalKey<FormState>();
  CreditCard? card;
  bool isDefault = false;
  bool isSaving = false;
  String? errorMessage;

  @override
  void onInit() async {
    super.onInit();
    card = Get.arguments as CreditCard?;
    isDefault = card?.isDefault ?? false;
    update();
  }

  void toggleDefault(bool value) {
    isDefault = value;
    update();
  }

  Future<void> updateCard() async {
    if (card?.id == null) {
      errorMessage = 'Invalid card';
      update();
      throw 'Invalid card';
    }
    isSaving = true;
    errorMessage = null;
    update();
    try {
      final res = await Api().put(
        '${Endpoints.paymentMethods}/${card!.id}',
        data: {
          'is_default': isDefault ? 1 : 0,
        },
      );
      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to update card';
      }
    } catch (e) {
      errorMessage = e.toString();
      update();
      rethrow;
    } finally {
      isSaving = false;
      update();
    }
  }

  Future<void> deleteCard() async {
    if (card?.id == null) throw 'Invalid card';
    try {
      final res = await Api().delete('${Endpoints.paymentMethods}/${card!.id}');
      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to delete card';
      }
    } catch (e) {
      rethrow;
    }
  }
}