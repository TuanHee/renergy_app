import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/snackbar.dart';

class GetHelpController extends GetxController {
  final String email = 'support@renergypowergroup.com';
  final String phone = '+6012-6433168';
  final String website = 'https://www.renergypowergroup.com';

  Future<void> openEmail() async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': 'Support Request'},
    );
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception catch (e) {
      if (Get.context != null) {
        Snackbar.showError('Email Error: $e', Get.context!);
      }
    }
  }

  Future<void> openChat() async {
    final digits = phone.replaceAll(RegExp(r'\D'), '');
    final uri = Uri.parse('https://wa.me/$digits');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception catch (e) {
      if (Get.context != null) {
        Snackbar.showError('Chat Error: $e', Get.context!);
      }
    }
  }

  Future<void> callPhone() async {
    final uri = Uri.parse('tel:$phone');
    try{
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception catch (e) {
      if (Get.context != null) {
        Snackbar.showError('Call Error: $e', Get.context!);
      }
    }
  }

  Future<void> openWebsite() async {
    final uri = Uri.parse(website);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } on Exception catch (e) {
      if (Get.context != null) {
        Snackbar.showError('Website Error: $e', Get.context!);
      }
    }
  }
}
