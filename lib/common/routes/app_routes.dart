import 'package:get/get.dart';
import 'package:renergy_app/common/middlewares/middlewares.dart';
import 'package:renergy_app/screens/screens.dart';

class AppRoutes {
  // Route names
  static const String splash = '/splash';
  static const String register = '/register';
  static const String login = '/login';
  static const String explorer = '/explorer';
  static const String charging = '/charging';
  static const String bookmark = '/bookmark';
  static const String account = '/account';
  static const String editProfile = '/edit-profile';
  static const String chargingStation = '/charging-station';
  static const String plugInLoading = '/plug-in-loading';
  static const String chargeProcessing = '/charge-processing';
  static const String card = '/card';
  static const String editCard = '/edit-card';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String getHelp = '/get-help';
  static const String faq = '/faq';
  static const String faqCategory = '/faq-category';
  static const String recharge = '/recharge';
  static const String car = '/car';
  static const String addCar = '/add-car';
  static const String editCar = '/edit-car';
  static const String paymentResult = '/payment-result';
  static const String filter = '/filter';

  // Initial route
  static const String initial = splash;

  static List<AuthMiddleware> authMiddleware = [AuthMiddleware()];

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
        binding: LoginBinding(),
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
        middlewares: authMiddleware,
      ),
      GetPage(
        name: bookmark,
        page: () => const BookmarkScreenView(),
        transition: Transition.fadeIn,
        binding: BookmarkBinding(),
        middlewares: authMiddleware,
      ),
      GetPage(
        name: account,
        page: () => const AccountScreenView(),
        transition: Transition.fadeIn,
        binding: AccountBinding(),
        middlewares: authMiddleware,
      ),
      GetPage(
        name: editProfile,
        page: () => const EditProfileScreenView(),
        transition: Transition.fadeIn,
        binding: EditProfileBinding(),
        middlewares: authMiddleware,
      ),
      GetPage(
        name: chargingStation,
        page: () => const StationScreenView(),
        transition: Transition.fadeIn,
        binding: StationBinding(),
        middlewares: authMiddleware,
      ),
      GetPage(
        name: plugInLoading,
        page: () => const PlugInLoadingScreenView(),
        transition: Transition.fadeIn,
        binding: PlugInLoadingBinding(),
        middlewares: authMiddleware,
      ),
      GetPage(
        name: chargeProcessing,
        page: () => const ChargeProcessingScreenView(),
        transition: Transition.fadeIn,
        binding: ChargeProcessingBinding(),
        middlewares: authMiddleware,
      ),
      GetPage(
        name: card,
        page: () => const CardScreenView(),
        transition: Transition.fadeIn,
        binding: CardBinding(),
        middlewares: authMiddleware,
      ),
      GetPage(
        name: editCard,
        page: () => const EditCardScreenView(),
        transition: Transition.fadeIn,
        binding: EditCardBinding(),
      ),
      GetPage(
        name: terms,
        page: () => const TermsScreenView(),
        transition: Transition.fadeIn,
        binding: TermsBinding(),
      ),
      GetPage(
        name: privacy,
        page: () => const PrivacyScreenView(),
        transition: Transition.fadeIn,
        binding: PrivacyBinding(),
      ),
      GetPage(
        name: getHelp,
        page: () => const GetHelpScreenView(),
        transition: Transition.fadeIn,
        binding: GetHelpBinding(),
      ),
      GetPage(
        name: faq,
        page: () => const FaqScreenView(),
        transition: Transition.fadeIn,
        binding: FaqBinding(),
      ),
      GetPage(
        name: faqCategory,
        page: () => const FaqCategoryScreenView(),
        transition: Transition.fadeIn,
        binding: FaqCategoryBinding(),
      ),
      GetPage(
        name: recharge,
        page: () => const RechargeScreenView(),
        transition: Transition.fadeIn,
        binding: RechargeBinding(),
        middlewares: authMiddleware,
      ),
      GetPage(
        name: car,
        page: () => const CarScreenView(),
        transition: Transition.fadeIn,
        binding: CarBinding(),
        middlewares: authMiddleware,
      ),
      GetPage(
        name: addCar,
        page: () => const AddCarScreenView(),
        transition: Transition.fadeIn,
        binding: AddCarBinding(),
        middlewares: authMiddleware,
      ),
      GetPage(
        name: editCar,
        page: () => const EditCarScreenView(),
        transition: Transition.fadeIn,
        binding: EditCarBinding(),
        middlewares: authMiddleware,
      ),
      GetPage(
        name: paymentResult,
        page: () => const PaymentResultScreenView(),
        transition: Transition.fadeIn,
        binding: PaymentResultBinding(),
        middlewares: authMiddleware,
      ),
      GetPage(
        name: filter,
        page: () => const FilterScreenView(),
        transition: Transition.fadeIn,
        binding: FilterBinding(),
      ),
      GetPage(
        name: register, 
        page: () => const RegisterScreenView(),
        transition: Transition.fadeIn,
        binding: RegisterBinding()
      ),
    ];
  }
}
