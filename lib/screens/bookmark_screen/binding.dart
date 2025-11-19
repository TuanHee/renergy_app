import 'package:get/get.dart';
import 'controller.dart';

class BookmarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(BookmarkController());
  }
}