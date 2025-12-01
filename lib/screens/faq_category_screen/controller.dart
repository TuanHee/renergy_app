import 'package:get/get.dart';

class FaqCategoryItem {
  final String key; // 'charging' or 'pricing'
  final String title;
  final String subtitle;
  FaqCategoryItem({required this.key, required this.title, required this.subtitle});
}

class FaqCategoryController extends GetxController {
  bool isLoading = false;
  List<FaqCategoryItem> categories = [
    FaqCategoryItem(
      key: 'charging',
      title: 'Enquiries on charging',
      subtitle: 'Stations, plugs, sessions and usage',
    ),
    FaqCategoryItem(
      key: 'pricing',
      title: 'Pricing & payment',
      subtitle: 'Fees, invoices and payment methods',
    ),
  ];
}