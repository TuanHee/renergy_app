import 'package:get/get.dart';
import 'package:renergy_app/common/models/creadit_card.dart';
import 'package:fiuu_mobile_xdk_flutter/fiuu_mobile_xdk_flutter.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/common/constants/endpoints.dart';


class CardController extends GetxController {
  bool isLoading = true;

  List<CreditCard> cards = [];

  

  @override
  void onInit() async {
    super.onInit();
    // cards = [
    //   CreditCard(
    //     cardNumber: '**** **** **** 9010',
    //     cardHolder: 'John Doe',
    //     expiryDate: '12/25',
    //     cvv: '123',
    //     cardType: CardType.visa,
    //   ),
    // ];
  }

  Future<void> addCard() async {
    try {
      final res = await Api().post(Endpoints.paymentMethods);
      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to init payment method';
      }
      final data = res.data['data']['params'];
      final Map<String, dynamic> params = data is Map<String, dynamic> ? data : {};
      print('param: $params');
      final String? result = await MobileXDK.start(params);
      print('result: $result');
    } catch (e) {
      rethrow;
    }

    
    // cards.add(card);
    // update();
  }

  Future<void> deleteCard(int index) async{
    
  }

  
}

