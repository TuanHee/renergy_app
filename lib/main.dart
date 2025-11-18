import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/app_theme.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/routes/app_routes.dart';

import 'common/constants/endpoints.dart';
import 'common/services/api_service.dart';

void main() {
  Get.put(MainController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Renergy App',
      theme: AppTheme.theme,
      initialRoute: AppRoutes.initial,
      getPages: AppRoutes.getPages(),
    );
  }
}

class MainController extends GetxController {
  Order? chargingOrder;

  Future<void> fetchChargingOrder() async {
    final res = await Api().post(Endpoints.isChanging);

    if (res.data['status'] != 200) {
      throw ('Is Changing Error: ${res.data['message'] ?? 'Unknown error'}');
    }

    // chargingOrder = res.data['data'] as Order;
  }
}

