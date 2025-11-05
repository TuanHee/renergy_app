import 'package:get/get.dart';
import 'package:renergy_app/screens/screens.dart';

class AppRoutes {
  // Route names
  static const String login = '/login';
  static const String explorer = '/explorer';
  static const String charging = '/charging';
  static const String bookmark = '/bookmark';
  static const String account = '/account';
  static const String chargingStation = '/charging-station';

  // Initial route
  static const String initial = explorer;

  // Get all routes
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: login,
        page: () => const LoginScreenView(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: explorer,
        page: () => const ExplorerScreenView(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: charging,
        page: () => const ChargingScreenView(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: bookmark,
        page: () => const BookmarkScreenView(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: account,
        page: () => const AccountScreenView(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: chargingStation,
        page: () => const ChargingStationScreenView(),
        transition: Transition.fadeIn,
        binding: ChargingStationBinding(),
      ),
    ];
  }
}
