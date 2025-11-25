import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/app_theme.dart';
import 'package:renergy_app/common/routes/app_routes.dart';

import 'common/services/firebase_notification.dart';

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