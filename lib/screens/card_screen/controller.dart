import 'package:get/get.dart';
import 'package:renergy_app/common/models/creadit_card.dart';
import 'package:fiuu_mobile_xdk_flutter/fiuu_mobile_xdk_flutter.dart';


class CardController extends GetxController {
  bool isLoading = true;
  String? errorMessage;

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
    // call api

    Map<String, dynamic> params = {}; // call payment method store api to get the params

    String? result = await MobileXDK.start(params);

    
    // cards.add(card);
    // update();
  }

  void deleteCard(int index) {
  }

  
}

