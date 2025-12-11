import 'package:get/get.dart';
import 'controller.dart';

class ReportHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportHistoryController>(() => ReportHistoryController());
  }
}