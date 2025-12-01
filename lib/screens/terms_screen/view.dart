import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class TermsScreenView extends StatelessWidget {
  const TermsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TermsController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Terms & Conditions'),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _TermsContent(content: controller.content),
            ),
          ),
        );
      },
    );
  }
}

class _TermsContent extends StatelessWidget {
  final String content;
  const _TermsContent({required this.content});

  @override
  Widget build(BuildContext context) {
    final parsed = _parse(content);
    final updated = parsed.updated;
    final intro = parsed.intro;
    final sections = parsed.sections;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (updated != null)
          Text(updated, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const SizedBox(height: 8),
        if (intro.isNotEmpty)
          Text(intro.join('\n'), style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5)),
        const SizedBox(height: 16),
        ...sections.map((s) => _SectionCard(title: s.title, paragraphs: s.paragraphs, bullets: s.bullets)),
      ],
    );
  }

  _ParsedTerms _parse(String raw) {
    final lines = raw.split('\n');
    String? updated;
    final intro = <String>[];
    final sections = <_Section>[];
    _Section? current;
    for (final l in lines) {
      final line = l.trim();
      if (line.isEmpty) continue;
      if (line.startsWith('Updated Effective Date:')) {
        updated = line;
        continue;
      }
      if (RegExp(r'^\d+\.\s').hasMatch(line)) {
        if (current != null) sections.add(current);
        current = _Section(title: line, paragraphs: [], bullets: []);
        continue;
      }
      if (line.startsWith('•')) {
        (current ??= _Section(title: '', paragraphs: [], bullets: [])).bullets.add(line.substring(1).trim());
        continue;
      }
      if (current == null) {
        intro.add(line);
      } else {
        current.paragraphs.add(line);
      }
    }
    if (current != null) sections.add(current);
    return _ParsedTerms(updated: updated, intro: intro, sections: sections);
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

class _Section {
  final String title;
  final List<String> paragraphs;
  final List<String> bullets;
  _Section({required this.title, required this.paragraphs, required this.bullets});
}

class _ParsedTerms {
  final String? updated;
  final List<String> intro;
  final List<_Section> sections;
  _ParsedTerms({required this.updated, required this.intro, required this.sections});
}