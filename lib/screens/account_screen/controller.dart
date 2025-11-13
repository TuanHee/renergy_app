import 'package:get/get.dart';

class AccountController extends GetxController {
  bool isLoading = true;

  @override
  void onInit() {
    super.onInit();
    fetchAccountDetails();
  }

  Future<void> fetchAccountDetails() async {
    isLoading = true;
    update();

    try {
      await Future<void>.delayed(const Duration(milliseconds: 300));
    } finally {
      isLoading = false;
      update();
    }
  }
}

