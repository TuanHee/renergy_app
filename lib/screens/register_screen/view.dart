import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/screens/register_screen/controller.dart';

class RegisterScreenView extends StatelessWidget {
  const RegisterScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RegisterController>(
      builder: (controller) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(padding: const EdgeInsets.all(24.0), child: Column(children: [Text('Register'),],),),
            ),
          ),
        );
      },
    );
  }
}