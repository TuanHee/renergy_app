import 'package:get/get.dart';
import 'package:renergy_app/common/models/creadit_card.dart';


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

  void addCard() {
    // call api

    
    // cards.add(card);
    // update();
  }

  void deleteCard(int index) {
  }

  
}

