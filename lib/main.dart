import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/app_theme.dart';
import 'package:renergy_app/common/routes/app_routes.dart';

import 'common/constants/server.dart';
import 'common/services/firebase_notification.dart';
import 'common/services/location_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    await Future.delayed(Duration(milliseconds: 1000));

    await NotificationService.init();
  } catch (e, st) {
    print('Firebase initializeApp error: $e\n$st');
  }

  final position = await LocationHandler.getCurrentLocation();
  print(position);

  runApp(const MyApp());
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
      child: Stack(
        children: [
          child,
          if (kDebugMode || serverApiUrl != "https://zeropowerstation.my")
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              color: Colors.red.withOpacity(0.7),
              child: const Text(
                kDebugMode
                    ? "DEBUG MODE"
                      : "STAGING MODE",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }
}