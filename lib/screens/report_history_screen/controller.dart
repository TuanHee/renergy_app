import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/common/constants/endpoints.dart';
import 'package:renergy_app/common/models/station_report.dart';

class ReportHistoryController extends GetxController {
  bool isLoading = true;
  List<StationReport> reports = [];

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  Future<void> fetchReports() async {
    isLoading = true;
    update();
    try {
      final res = await Api().get(Endpoints.stationReports);
      // Accept list in various response shapes
      final parsed = StationReport.listFromJson(res.data['data'] ?? res.data);
      reports = parsed;
    } catch (e) {
      reports = [];
    } finally {
      isLoading = false;
      update();
    }
  }

  Color statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return const Color(0xFF0BB07B); // green
      case 'pending':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}