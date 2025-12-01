import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/components/badge.dart';
import 'package:renergy_app/common/models/bay.dart';
import 'controller.dart';

class ReportScreenView extends StatelessWidget {
  const ReportScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReportController>(
      builder: (controller) {
        final station = controller.station;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Get.back(),
            ),
            title: const Text(
              'Report',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kindly tell us the reason you reporting this bay?',
                    style: TextStyle(color: Colors.black87, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/icons/app_icon.jpg',
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: const [
                                  MyBadge(label: 'Public', color: Colors.green),
                                  SizedBox(width: 8),
                                  MyBadge(label: 'Showroom', color: Colors.black, dark: true),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                station.name ?? 'Unknown Station',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  _LabeledDropdown<Bay>(
                    label: 'Location Bay *',
                    hint: 'Select Bay',
                    items: controller.bays,
                    itemBuilder: (bay) => Text(
                      bay.name ?? 'Bay ${bay.id ?? ''}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    value: controller.selectedBay,
                    onChanged: controller.setBay,
                  ),
                  const SizedBox(height: 16),
                  _LabeledDropdown<String>(
                    label: 'Location Port',
                    hint: 'Select Port',
                    items: controller.portOptions,
                    itemBuilder: (p) => Text(
                      p,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    value: null,
                    onChanged: controller.setPortByString,
                    enabled: controller.portOptions.isNotEmpty,
                  ),
                  const SizedBox(height: 16),
                  _LabeledDropdown<String>(
                    label: 'Report Reason *',
                    hint: controller.isLoadingReasons ? 'Loading reasons...' : 'Report Reason',
                    items: controller.reasons,
                    itemBuilder: (r) => Text(
                      r,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    value: controller.selectedReason,
                    onChanged: controller.setReason,
                    enabled: controller.reasons.isNotEmpty,
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () => controller.submit(context),
                  child: const Text('Submit'),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LabeledDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final List<T> items;
  final Widget Function(T item) itemBuilder;
  final T? value;
  final void Function(T?) onChanged;
  final bool enabled;

  const _LabeledDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.items,
    required this.itemBuilder,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<T>(
          value: value,
          isExpanded: true,
          onChanged: enabled ? onChanged : null,
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: DefaultTextStyle.merge(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: itemBuilder(e),
                    ),
                  ),
                ),
              )
              .toList(),
          selectedItemBuilder: (context) => items
              .map(
                (e) => Align(
                  alignment: Alignment.centerLeft,
                  child: DefaultTextStyle.merge(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    child: itemBuilder(e),
                  ),
                ),
              )
              .toList(),
          decoration: InputDecoration(
            hintText: hint,
            isDense: true,
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}