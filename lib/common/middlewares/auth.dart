import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/services/storage_service.dart';

import '../../global.dart';
import '../constants/constants.dart';
import '../routes/app_routes.dart';
import '../services/services.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    String? accessToken = StorageService.to.getString(storageAccessToken);
    if (accessToken != null && accessToken != '') {
      Global.checkLoginStatus();
      if (!Global.isLoginValid) {
        return const RouteSettings(name: AppRoutes.login);
      }
      return null;
    }
    return const RouteSettings(name: AppRoutes.login);
  }
}
