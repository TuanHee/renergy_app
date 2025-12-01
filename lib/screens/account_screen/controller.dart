import 'package:get/get.dart';
import 'package:renergy_app/common/models/customer.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/storage_service.dart';
import 'package:renergy_app/global.dart';

import '../../common/constants/storage.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/common/constants/endpoints.dart';

class AccountController extends GetxController {
  bool isLoading = true;
  Customer? customer;
  String? errorMessage;

  @override
  void onInit() {
    super.onInit();
    fetchAccountDetails();
  }

  Future<void> fetchAccountDetails() async {
    isLoading = true;
    update();

    try {
      final res = await Api().get(Endpoints.user);
      if (res.data['status'] >= 200 && res.data['status'] < 300) {
        final data = res.data['data'];
        final profileJson = (data is Map<String, dynamic>)
            ? (data['user'] ?? data['customer'] ?? data)
            : null;
        if (profileJson is Map<String, dynamic>) {
          print('fetchAccountJson: $profileJson');
          customer = Customer.fromJson(profileJson);
          print('Customer: ${customer?.toJson()}');
        }
      } else {
        errorMessage = res.data['message']?.toString();
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> logout() async {
    try {
      StorageService.to.remove(storageAccessToken);
      Global.isLoginValid = false;
      Get.offAllNamed(AppRoutes.explorer);
    } catch (e) {
      print(e);
    }
  }
}
