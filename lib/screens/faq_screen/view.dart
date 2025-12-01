import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class FaqScreenView extends StatelessWidget {
  const FaqScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FaqController>(
      builder: (controller) {
        final theme = Theme.of(context);
        final title = _titleFromCategory(controller.category);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(title),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 44,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: controller.updateSearchQuery,
                            decoration: InputDecoration(
                              hintText: 'Search help topics',
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...controller.filteredItems.asMap().entries.map((e) {
                    final idx = e.key;
                    final item = e.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Theme(
                        data: theme.copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          initiallyExpanded: item.expanded,
                          onExpansionChanged: (_) => controller.toggleExpanded(idx),
                          tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                          iconColor: Colors.red,
                          collapsedIconColor: Colors.grey.shade600,
                          title: Text(item.question, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                          children: [
                            Text(item.answer, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5)),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

String _titleFromCategory(String? category) {
  if (category == 'charging') return 'Enquiries On Charging';
  if (category == 'pricing') return 'PRICING & PAYMENT';
  return 'FAQ';
}