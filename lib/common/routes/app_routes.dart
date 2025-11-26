import 'package:get/get.dart';
import 'package:renergy_app/screens/screens.dart';

class AppRoutes {
  // Route names
  static const String splash = '/splash';
  static const String login = '/login';
  static const String explorer = '/explorer';
  static const String charging = '/charging';
  static const String bookmark = '/bookmark';
  static const String account = '/account';
  static const String chargingStation = '/charging-station';
  static const String plugInLoading = '/plug-in-loading';
  static const String chargeProcessing = '/charge-processing';
  static const String card = '/card';
  static const String recharge = '/recharge';
  static const String car = '/car';
  static const String addCar = '/add-car';
  static const String editCar = '/edit-car';
  static const String paymentResult = '/payment-result';
  static const String filter = '/filter';

  // Initial route
  static const String initial = splash;

  // Get all routes
  static List<GetPage> getPages() {
    return [
      GetPage(
        name: splash,
        page: () => const SplashScreenView(),
        transition: Transition.fadeIn,
        binding: SplashBinding(),
      ),
      GetPage(
        name: login,
        page: () => const LoginScreenView(),
        transition: Transition.fadeIn,
      ),
      GetPage(
        name: explorer,
        page: () => const ExplorerScreenView(),
        transition: Transition.fadeIn,
        binding: ExplorerBinding(),
      ),
      GetPage(
        name: charging,
        page: () => const ChargingScreenView(),
        transition: Transition.fadeIn,
        binding: ChargingBinding(),
      ),
      GetPage(
        name: bookmark,
        page: () => const BookmarkScreenView(),
        transition: Transition.fadeIn,
        binding: BookmarkBinding(),
      ),
      GetPage(
        name: account,
        page: () => const AccountScreenView(),
        transition: Transition.fadeIn,
        binding: AccountBinding(),
      ),
      GetPage(
        name: chargingStation,
        page: () => const StationScreenView(),
        transition: Transition.fadeIn,
        binding: StationBinding(),
      ),
      GetPage(
        name: plugInLoading,
        page: () => const PlugInLoadingScreenView(),
        transition: Transition.fadeIn,
        binding: PlugInLoadingBinding(),
      ),
      GetPage(
        name: chargeProcessing,
        page: () => const ChargeProcessingScreenView(),
        transition: Transition.fadeIn,
        binding: ChargeProcessingBinding(),
      ),
      GetPage(
        name: card,
        page: () => const CardScreenView(),
        transition: Transition.fadeIn,
        binding: CardBinding(),
      ),
      GetPage(
        name: recharge,
        page: () => const RechargeScreenView(),
        transition: Transition.fadeIn,
        binding: RechargeBinding(),
      ),
      GetPage(
        name: car,
        page: () => const CarScreenView(),
        transition: Transition.fadeIn,
        binding: CarBinding(),
      ),
      GetPage(
        name: addCar,
        page: () => const AddCarScreenView(),
        transition: Transition.fadeIn,
        binding: AddCarBinding(),
      ),
      GetPage(
        name: editCar,
        page: () => const EditCarScreenView(),
        transition: Transition.fadeIn,
        binding: EditCarBinding(),
      ),
      GetPage(
        name: paymentResult,
        page: () => const PaymentResultScreenView(),
        transition: Transition.fadeIn,
        binding: PaymentResultBinding(),
      ),
      GetPage(
        name: filter,
        page: () => const FilterScreenView(),
        transition: Transition.fadeIn,
        binding: FilterBinding(),
      ),
    ];
  }
}
