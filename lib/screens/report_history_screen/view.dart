import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/components/badge.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'controller.dart';

class ReportHistoryScreenView extends StatelessWidget {
  const ReportHistoryScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportHistoryController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              'Report History',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.reports.isEmpty
                  ? const Center(child: Text('No report history yet'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.reports.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = controller.reports[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Date header
                            Text(
                              item.formattedDate(),
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Card
                            InkWell(
                              onTap: () => Get.toNamed(AppRoutes.reportDetail, arguments: item),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
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
                                            item.stationName ?? 'Unknown Station',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.chevron_right, color: Colors.black54),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Bay tag
                                    MyBadge(
                                      label: item.bayName ?? (item.bayId != null ? 'BAY${item.bayId}' : 'BAY'),
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Report Reason',
                                      style: TextStyle(color: Colors.black54, fontSize: 12),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.reason ?? '-',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    // Status badge
                                    MyBadge(
                                      label: (item.status ?? 'Unknown'),
                                      color: controller.statusColor(item.status),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
        );
      },
    );
  }
}