import 'dart:developer';

import 'package:get/get.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/constants/enums.dart';
import 'package:renergy_app/common/models/station.dart';
import 'package:renergy_app/common/services/api_service.dart';

class ExplorerController extends GetxController {
  bool isLoading = true;
  String? errorMessage;
  List<Station> stations = [];

  @override
  void onInit() async {
    super.onInit();
    await fetchStations();

    update();
  }

  Future<void> fetchStations() async {
    isLoading = true;
    errorMessage = null;

    try {
      final res = await Api().get(Endpoints.stations);

      if (res.data['status'] == 200) {
        final data = res.data['data'];

        if (data['stations'] is List) {
          stations = Station.listFromJson(res.data['data']['stations']);
        }
      } else {
        errorMessage = res.data['message'] ?? 'Failed to fetch stations';
      }
    } catch (e) {
      errorMessage = e.toString();
      print('ExplorerController.fetchStations error: $e');
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
}

