import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/components/components.dart';
import 'package:renergy_app/screens/account_screen/account_screen.dart';

class AccountScreenView extends StatelessWidget {
  const AccountScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Account'),
          ),
          body: controller.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                      child: Text('Account Screen'),
                    ),
                  ElevatedButton(
                    onPressed: controller.addPaymentMethod,
                    child: const Text('Add Payment Method'),
                  ),
                ],
              ),
          bottomNavigationBar: MainBottomNavBar(
            currentIndex: 3,
          ),
        );
      },
    );
  }
}
