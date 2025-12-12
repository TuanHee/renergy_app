import 'package:get/get.dart';
import 'controller.dart';

class ReportDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportDetailController>(() => ReportDetailController());
  }
}