import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/routes/app_routes.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const MainBottomNavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, -1)),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            // Navigate to corresponding route
            switch (index) {
              case 0:
                Get.offNamed(AppRoutes.explorer);
                break;
              case 1:
                Get.offNamed(AppRoutes.charging);
                break;
              case 2:
                Get.offNamed(AppRoutes.bookmark);
                break;
              case 3:
                Get.offNamed(AppRoutes.account);
                break;
            }
          },
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.ev_station), label: 'Charging'),
            BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Bookmark'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Account'),
          ],
        ),
      ),
    );
  }
}
