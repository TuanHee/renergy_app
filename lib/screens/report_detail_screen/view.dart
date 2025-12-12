import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/components/badge.dart';
import 'package:renergy_app/common/models/station_report.dart';
import 'controller.dart';

class ReportDetailScreenView extends StatelessWidget {
  const ReportDetailScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GetBuilder<ReportDetailController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              'Report Details',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.report == null
                  ? const Center(child: Text('Unable to load report'))
                  : _ReportDetailBody(controller: controller, theme: theme),
        );
      },
    );
  }
}

class _ReportDetailBody extends StatelessWidget {
  final ReportDetailController controller;
  final ThemeData theme;
  const _ReportDetailBody({required this.controller, required this.theme});

  @override
  Widget build(BuildContext context) {
    final report = controller.report!;
    final station = report.station;
    final bayLabel = report.bay?.name ?? (report.bayId != null
        ? 'BAY${report.bayId!.toString().padLeft(2, '0')}'
        : 'BAY');

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          report.formattedDate(),
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      MyBadge(
                        label: report.status ?? 'Unknown',
                        color: controller.statusColor(report.status),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if ((station?.type ?? report.type)?.isNotEmpty ?? false)
                        MyBadge(label: station?.type ?? report.type!, color: const Color(0xFF0BB07B)),
                      if ((station?.category)?.isNotEmpty ?? false)
                        MyBadge(label: station!.category!, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    report.stationName ?? station?.name ?? 'Unknown Station',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  MyBadge(label: bayLabel, color: Colors.grey),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _Section(label: 'Transaction ID', value: _transactionId(report)),
            const SizedBox(height: 16),
            _Section(label: 'Request Reason', value: report.reason ?? '-'),
            const SizedBox(height: 16),
            _Section(label: 'Description', value: report.description ?? '-'),
            const SizedBox(height: 16),
            _Section(label: 'Remarks', value: report.remark ?? '-'),
          ],
        ),
      ),
    );
  }

  String _transactionId(StationReport report) {
    final id = report.order?.invoiceNo ?? report.order?.id?.toString();
    if (id == null || id.isEmpty) return '#';
    return id.startsWith('#') ? id : '#$id';
  }
}

class _Section extends StatelessWidget {
  final String label;
  final String value;
  const _Section({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}