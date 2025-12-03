import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/models/notification.dart';
import 'package:renergy_app/components/snackbar.dart';

import '../../common/services/api_service.dart';

class NotificationController extends GetxController {
  List<AppNotification> notifications = [];

  int get unreadCount => 0;

  @override
  void onInit() {
    super.onInit();
    fetchNotification();
  }

  void markAllRead() {
    // No-op for new schema; hook up to backend later
    update();
  }

  void toggleRead(int index) {
    // No-op tap handler for new schema; use goto navigation in view
    update();
  }

  void deleteAt(int index) {
    if (index < 0 || index >= notifications.length) return;
    notifications.removeAt(index);
    update();
  }

  Future<void> fetchNotification({
    Function(String msg)? onErrorCallback,
  }) async {
    try {
      final res = await Api().get(Endpoints.notifications);

      if (res.data['status'] == 200) {
        final data = res.data['data'];
        print('data: $data');

        if (data['notifications'] is List) {
          notifications = AppNotification.listFromJson(data['notifications']);
          print(notifications.first.toJson());
        }
      } else {
        throw res.data['message'] ??
            'Failed to fetch unread notification count';
      }
    } catch (e) {
      if (Get.context == null) {
        return;
      }
      Snackbar.showError(e.toString(), Get.context!);
    } finally {
      update();
    }
  }
}