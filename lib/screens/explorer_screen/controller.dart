import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/bookmark.dart';
import 'package:renergy_app/common/models/order.dart';
import 'package:renergy_app/common/models/station.dart';
import 'package:renergy_app/common/services/api_service.dart';

class ExplorerController extends GetxController {
  bool isLoading = true;
  List<Station> stations = [];
  List<Bookmark> bookmarks = [];
  Order? chargingOrder;
  String? status;
  Timer? chargingOrderTimer;

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onClose() {
    chargingOrderTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchStations({Function(String msg)? onErrorCallback}) async {
    try {
      final res = await Api().get(Endpoints.stations);

      if (res.data['status'] == 200) {
        final data = res.data['data'];

        if (data['stations'] is List) {
          stations = Station.listFromJson(res.data['data']['stations']);
        }
      } else {
        throw res.data['message'] ?? 'Failed to fetch stations';
      }
    } catch (e) {
      
      onErrorCallback?.call(e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  int getAvailableBayCount(Station station) {
    return station.bays
            ?.where((bay) => bay.status == BayStatus.available)
            .length ??
        0;
  }

  Future<void> fetchBookmark({Function(String msg)? onErrorCallback}) async {
    try {
      final res = await Api().get(Endpoints.bookmarks);

      if (res.data['status'] != 200) {
        throw ('Failed to fetch Bookmark: ${res.data['message']}');
      }

      if (res.data['data']['bookmarks'] is! List) {
        throw ('Failed to fetch Bookmark: bookmarks is not a list');
      }

      bookmarks = (res.data['data']['bookmarks'] as List)
          .map((element) => Bookmark.fromJson(element))
          .toList();
    } catch (e) {
      onErrorCallback?.call(e.toString());
    }
  }

  Future<void> storeBookmark(Station station) async {
    final newBookmark = Bookmark(stationId: station.id, station: station);
    bookmarks.add(newBookmark);
    update();
    try {
      final res = await Api().post(
        Endpoints.bookmarks,
        data: {'station_id': station.id},
      );

      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to add bookmark';
      }

      bookmarks.last = Bookmark.fromJson(res.data['data']['bookmark']);
    } catch (e) {
      bookmarks.removeLast();
      update();
      rethrow;
    }
  }

  Future<void> removeBookmark(int? bookmarkId) async {
    if (bookmarkId == null) {
      throw 'Failed to remove bookmark: Try it Later';
    }
    final removed = bookmarks.firstWhereOrNull((e) => e.id == bookmarkId);

    if (removed == null) {
      throw 'Failed to remove bookmark: do not have this bookmark';
    }
    bookmarks.remove(removed);
    update();

    try {
      final res = await Api().delete(Endpoints.bookmark(bookmarkId));

      if (res.data['status'] != 200) {
        throw res.data['message'] ?? 'Failed to remove bookmark';
      }
    } catch (e) {
      bookmarks.add(removed);
      update();
      rethrow;
    }
  }

  Future<void> pollChargingOrder({Function(String msg)? onErrorCallback}) async {
    chargingOrderTimer = Timer.periodic(const Duration(seconds: 2), (
      timer,
    ) async {
      try {
        final res = await Api().get(Endpoints.activeOrder);

        if (res.data['status'] >= 200 && res.data['status'] < 300) {
          final data = res.data['data'];
          final newStatus = data['status'];
          final newOrder = data['order'] != null ? Order.fromJson(data['order']) : null;
          final changedStatus = newStatus != null && status != newStatus;
          final changedOrder = (chargingOrder?.id ?? -1) != (newOrder?.id ?? -1);

          if (changedStatus || changedOrder) {
            status = newStatus ?? status;
            chargingOrder = newOrder;
            
            update();
          }
        }
      } catch (e, stackTrace) {
        onErrorCallback?.call('Error polling charging order: $e, $stackTrace');
      }
    });
  }

  void stopPollingChargingOrder() {
    chargingOrderTimer?.cancel();
  }
}
