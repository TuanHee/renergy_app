import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:renergy_app/common/constants/app_theme.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/common/services/firebase_notification.dart';
import 'package:renergy_app/firebase_options.dart';
import 'package:renergy_app/global.dart';
import 'package:upgrader/upgrader.dart';

import 'common/constants/server.dart';
import 'common/services/location_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Upgrader.clearSavedSettings();
  await Global.init();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    await NotificationService.init();
  } catch (e, st) {
    print('Firebase initializeApp error: $e\n$st');
  }

  final mainController = Get.put(MainController());
  mainController.position = await LocationHandler.getCurrentLocation();
  printLocalVersion();
  printStoreVersion();
  runApp(const MyApp());
}

Future<void> printLocalVersion() async {
  final info = await PackageInfo.fromPlatform();

  print("Local versionName: ${info.version}");
  print("Local versionCode (build number): ${info.buildNumber}");
}

Future<void> printStoreVersion() async {
  final upgrader = Upgrader();

  // Load store info
  await upgrader.initialize();

  print("Store version: ${upgrader.currentAppStoreVersion}");
  // print("Store release notes: ${upgrader.}");
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DebugWrapper(
      child: GetMaterialApp(
        title: 'Renergy App',
        theme: AppTheme.theme,
        initialRoute: AppRoutes.initial,
        getPages: AppRoutes.getPages(),
      ),
    );
  }
}

class DebugWrapper extends StatelessWidget {
  final Widget child;

  const DebugWrapper({super.key, required this.child, BuildContext? context});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          textScaleFactor: MediaQuery.of(context).textScaleFactor * 1.08,
        ),
        child: Stack(
          children: [
            child,
            if (kDebugMode || serverApiUrl == "https://ocpp.marslab.com.my")
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  color: Colors.red.withOpacity(0.7),
                  child: Text(
                    kDebugMode ? "DEBUG MODE" : "STAGING MODE",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MainController extends GetxController {
  Position? position;
}
