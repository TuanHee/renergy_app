import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class PrivacyScreenView extends StatelessWidget {
  const PrivacyScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrivacyController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Privacy Policy'),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: controller.sections.map((s) => _SectionCard(title: s.title, paragraphs: s.paragraphs, bullets: s.bullets)).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<String> paragraphs;
  final List<String> bullets;
  const _SectionCard({required this.title, required this.paragraphs, required this.bullets});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.red)),
          const SizedBox(height: 8),
          ...paragraphs.map((p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(p, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5)),
              )),
          if (bullets.isNotEmpty) const SizedBox(height: 6),
          ...bullets.map((b) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Icon(Icons.circle, size: 6, color: Colors.red),
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(b, style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}