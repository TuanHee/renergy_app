import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import 'package:renergy_app/common/routes/app_routes.dart';

class FaqCategoryScreenView extends StatelessWidget {
  const FaqCategoryScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FaqCategoryController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('FAQ'),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ...controller.categories.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CategoryCard(
                          icon: c.key == 'pricing' ? Icons.payments_outlined : Icons.ev_station,
                          title: c.title,
                          subtitle: c.subtitle,
                          onTap: () => Get.toNamed(AppRoutes.faq, arguments: {'category': c.key}),
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  const _CategoryCard({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.red),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}