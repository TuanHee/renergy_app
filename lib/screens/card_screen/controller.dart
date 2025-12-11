import 'dart:convert';

import 'package:get/get.dart';
import 'package:renergy_app/common/models/credit_card.dart';
import 'package:fiuu_mobile_xdk_flutter/fiuu_mobile_xdk_flutter.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/components/snackbar.dart';

class CardController extends GetxController {
  bool isLoading = true;
  bool isSettingDefault = false;
  bool isSelectingCard = false;

  List<CreditCard> cards = [];

  @override
  void onInit() async {
    super.onInit();
    final args = Get.arguments;
    if (args is bool && args) {
      isSelectingCard = args;
    } else if (args is Map && args['isSelectingCard'] != null) {
      isSelectingCard = args['isSelectingCard'];
    }

    await fetchCardIndex();
  }

  Future<void> fetchCardIndex() async {
    isLoading = true;
    update();
    try {
      final res = await Api().get(Endpoints.paymentMethods);
      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to fetch payment methods';
      }
      final data = res.data['data'];
      final cardsJson = (data is Map && data['cards'] is List)
          ? List<Map<String, dynamic>>.from(data['cards'])
          : <Map<String, dynamic>>[];
      cards = cardsJson.map((json) => CreditCard.fromJson(json)).toList();
      update();
    } catch (e) {
      rethrow;
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> addCard() async {
    try {
      final initPaymentRes = await Api().post(Endpoints.paymentMethods);
      if (initPaymentRes.data['status'] != 200) {
        throw initPaymentRes.data['message'] ?? 'Failed to init payment method';
      }
      final data = initPaymentRes.data['data']['params'];
      final Map<String, dynamic> params = data is Map<String, dynamic>
          ? data
          : {};
      final String? result = await MobileXDK.start(params);
      print(result);

      if (result == null) throw 'Failed to add card: no return from XDK';
      final handleRes = await Api().post(Endpoints.handlePayment, data: jsonDecode(result));
      if (handleRes.data['status'] != 200) {
        throw handleRes.data['message'] ?? 'Failed to handle Payment';
      }

      await fetchCardIndex();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteCard(CreditCard card) async {
    try {
      if (card.id == null) throw 'Invalid card';

      final res = await Api().delete('${Endpoints.paymentMethods}/${card.id}');
      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to delete card';
      }
    } catch (e) {
      if (Get.context != null) {
        Snackbar.showError(e.toString(), Get.context!);
      }
    } finally {
      await fetchCardIndex();
    }
  }

  Future<void> setDefaultCard(CreditCard card) async {
    isSettingDefault = true;
    update();
    try {
      if (card.id == null) {
        throw 'Invalid card';
      }
      final res = await Api().put('${Endpoints.paymentMethods}/${card.id}');
      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to update card';
      }
    } catch (e) {
      if (Get.context != null) {
        Snackbar.showError(e.toString(), Get.context!);
      }
    } finally {
      isSettingDefault = false;
      await fetchCardIndex();
      update();
    }
  }
}
