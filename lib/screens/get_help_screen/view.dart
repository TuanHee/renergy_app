import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';

class GetHelpScreenView extends StatelessWidget {
  const GetHelpScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetHelpController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Help'),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(60),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Icon(Icons.support_agent, size: 56, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  const Text('How can we help you today?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(
                    "We're here to assist you in any way we can. Please contact us if you have any questions or concerns.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 20),
                  _HelpItem(icon: Icons.email_outlined, label: controller.email, onTap: controller.openEmail),
                  const Divider(height: 1),
                  _HelpItem(icon: Icons.chat_bubble_outline, label: 'Live chat', onTap: controller.openChat),
                  const Divider(height: 1),
                  _HelpItem(icon: Icons.phone_outlined, label: controller.phone, onTap: controller.callPhone),
                  const SizedBox(height: 24),
                  Expanded(child: Container()),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Visit our website ', style: TextStyle(fontSize: 13, color: Colors.black87)),
                        GestureDetector(
                          onTap: controller.openWebsite,
                          child: const Text('Renergy Power Group', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _HelpItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}