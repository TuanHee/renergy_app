import 'package:flutter/material.dart';
import 'package:renergy_app/components/components.dart';

class AccountScreenView extends StatelessWidget {
  const AccountScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
      ),
      body: const Center(
        child: Text('Account Screen'),
      ),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: 3,
      ),
    );
  }
}
