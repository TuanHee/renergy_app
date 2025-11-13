import 'package:get/get.dart';
import 'package:renergy_app/screens/account_screen/account_screen.dart';

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountController());
  }
}

