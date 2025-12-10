import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:renergy_app/common/models/station.dart';
import 'package:renergy_app/common/models/bay.dart';
import 'package:renergy_app/common/models/port.dart';
import 'package:renergy_app/components/snackbar.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/common/constants/endpoints.dart';

class ReportController extends GetxController {
  late Station station;
  Bay? selectedBay;
  Port? selectedPort;
  String? selectedReason;

  List<String> reasons = [];
  bool isLoadingReasons = false;
  // add submit loading flag
  bool isSubmitting = false;

  @override
  void onInit() async {
    super.onInit();
    final args = Get.arguments;
    if (args is Station) {
      station = args;
    } else if (args is Map && args['station'] is Station) {
      station = args['station'] as Station;
    } else if (args is int) {
      try {
        final res = await Api().get(Endpoints.station(args));
        if (res.data['status'] == 200) {
          station = Station.fromJson(res.data['data']['station']);
        } else {
          station = Station(name: 'Unknown');
        }
      } catch (e) {
        station = Station(name: 'Unknown');
      }
    } else if (args is Map && args['stationId'] is int) {
      final id = args['stationId'] as int;
      try {
        final res = await Api().get(Endpoints.station(id));
        if (res.data['status'] == 200) {
          station = Station.fromJson(res.data['data']['station']);
        } else {
          station = Station(name: 'Unknown');
        }
      } catch (e) {
        station = Station(name: 'Unknown');
      }
    } else {
      station = Station(name: 'Unknown');
    }

    await fetchReasons();
    update();
  }

  Future<void> fetchReasons() async {
    isLoadingReasons = true;
    update();
    try {
      final stationId = station.id;

      List<String> parsed = [];

      if (stationId != null) {
        final resStation = await Api().get(Endpoints.reportReasons);
        parsed = _parseReasons(resStation);
      }

      if (parsed.isEmpty) {
        final resGeneric = await Api().get('report-reasons');
        parsed = _parseReasons(resGeneric);
      }

      reasons = parsed.isNotEmpty
          ? parsed
        : [];
    } catch (e) {
    } finally {
      isLoadingReasons = false;
      update();
    }
  }

  List<String> _parseReasons(dio.Response res) {
    try {
      final data = res.data['data'];
      final list = (data is Map && data['reasons'] is List)
          ? List<String>.from(data['reasons'].map((e) => e.toString()))
          : (res.data['reasons'] is List)
              ? List<String>.from(res.data['reasons'].map((e) => e.toString()))
              : <String>[];
      return list;
    } catch (_) {
      return <String>[];
    }
  }

  List<Bay> get bays => station.bays ?? <Bay>[];

  List<String> get portOptions {
    final port = selectedBay?.port;
    if (port == null) return [];
    final type = port.portType ?? '';
    return type.isNotEmpty ? [type] : [];
  }

  void setBay(Bay? bay) {
    selectedBay = bay;
    selectedPort = bay?.port;
    update();
  }

  void setPortByString(String? value) {
    if (value == null) return;
    selectedPort = selectedBay?.port;
    update();
  }

  void setReason(String? value) {
    selectedReason = value;
    update();
  }

  Future<void> submit(BuildContext context) async {
    if (selectedBay == null || selectedReason == null || selectedPort == null) {
      Snackbar.showError('Please select required fields', context);
      return;
    }
    // show submitting overlay
    isSubmitting = true;
    update();
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    try {
      final payload = {
        'station_id': station.id,
        'bay_id': selectedBay!.id,
        'charger_port_id': selectedPort!.id,
        'reason': selectedReason,
      };
      final res = await Api().post(Endpoints.stationReports, data: payload);
      if (res.data['status'] == 200 || res.statusCode == 200) {
        if (Get.isDialogOpen == true) Get.back(); // close loading
        Snackbar.showSuccess('Report submitted. Thank you!', context);
        Get.back(); // navigate back
      } else {
        final msg = res.data['message']?.toString() ?? 'Failed to submit report';
        if (Get.isDialogOpen == true) Get.back(); // close loading
        Snackbar.showError(msg, context);
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back(); // close loading
      Snackbar.showError(e.toString(), context);
    } finally {
      isSubmitting = false;
      update();
    }
  }
}