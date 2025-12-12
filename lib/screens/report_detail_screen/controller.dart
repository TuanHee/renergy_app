import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:renergy_app/common/models/station_report.dart';
import 'package:renergy_app/common/services/api_service.dart';
import 'package:renergy_app/common/constants/endpoints.dart';

class ReportDetailController extends GetxController {
  bool isLoading = true;
  StationReport? report;

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    final args = Get.arguments;
    try {
      if (args is StationReport) {
        report = args;
        isLoading = false;
        update();
        return;
      }
      if (args is Map && args['report'] is StationReport) {
        report = args['report'] as StationReport;
        isLoading = false;
        update();
        return;
      }
      if (args is int) {
        await fetchReportById(args);
        return;
      }
      if (args is Map && args['id'] is int) {
        await fetchReportById(args['id'] as int);
        return;
      }
    } catch (_) {}
    isLoading = false;
    update();
  }

  Future<void> fetchReportById(int id) async {
    isLoading = true;
    update();
    try {
      final res = await Api().get(Endpoints.stationReport(id));
      final data = res.data['data'] ?? res.data;
      final json = (data is Map && data['station_report'] is Map)
          ? data['station_report'] as Map<String, dynamic>
          : (data is Map && data['report'] is Map)
              ? data['report'] as Map<String, dynamic>
              : data as Map<String, dynamic>;
      report = StationReport.fromJson(json);
    } catch (_) {
      report = null;
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