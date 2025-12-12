import 'dart:async';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';
import '../../common/routes/app_routes.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/global.dart';

class SplashScreenController extends GetxController {
  Timer? _timer;
  bool shouldPauseNavigation = false;

  @override
  void onInit() {
    super.onInit();
    _fetchLoginMethod();
    _checkUpgradeAndMaybeNavigate();
  }

  Future<void> _fetchLoginMethod() async {
    try {
      final res = await Api().get(Endpoints.loginMethod);
      final method = (res.data['method'] ?? res.data['data']?['method'] ?? 'phone')
          .toString()
          .toLowerCase();
      Global.isGoogleLoginOnly = method == 'google';
    } catch (_) {
      Global.isGoogleLoginOnly = false;
    }
  }

  Future<void> _checkUpgradeAndMaybeNavigate() async {
    // Ensure upgrader checks immediately without delay
    final upgrader = Upgrader(durationUntilAlertAgain: Duration.zero);
    // Initialize to fetch store version and decision flags
    await upgrader.initialize();

    // If an upgrade should be displayed, pause navigation
    final showUpgrade = upgrader.shouldDisplayUpgrade();
    if (showUpgrade) {
      shouldPauseNavigation = true;
      update();
      return;
    }

    // Otherwise proceed with normal splash navigation
    _navigateToHome();
  }

  void _navigateToHome() {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 3), () {
      Get.offAllNamed(AppRoutes.explorer);
    });
  }

  // Call this after the upgrade dialog is dismissed with Ignore/Later
  void resumeAfterUpgradeDismissed() {
    if (!shouldPauseNavigation) return;
    shouldPauseNavigation = false;
    update();
    // Schedule navigation shortly after the dialog dismisses
    Future.delayed(const Duration(milliseconds: 50), () {
      Get.offAllNamed(AppRoutes.explorer);
    });
  }
}

