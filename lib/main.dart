import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/constants/app_theme.dart';
import 'package:renergy_app/common/routes/app_routes.dart';

void main() {
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
