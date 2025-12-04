import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/routes/app_routes.dart';

bool _isNavigating = false;

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const MainBottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        bottom: false,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: (index) {
            // if (currentIndex == index || _isNavigating) return;
            _isNavigating = true;
            // Navigate to corresponding route
            switch (index) {
              case 0:
                Get.offAllNamed(AppRoutes.explorer);
                break;
              case 1:
                Get.offAllNamed(AppRoutes.charging);
                break;
              case 2:
                Get.offAllNamed(AppRoutes.bookmark);
                break;
              case 3:
                Get.offAllNamed(AppRoutes.account);
                break;
            }
            _isNavigating = false;
          },
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/images/pin_point.png',
                height: 24,
                fit: BoxFit.contain,
              ),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.ev_station),
              label: 'Charging',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_border),
              label: 'Bookmark',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }
}
