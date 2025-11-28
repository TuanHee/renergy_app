import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/components/snackbar.dart';
import 'controller.dart';

class EditCardScreenView extends StatelessWidget {
  const EditCardScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditCardController>(
      builder: (controller) {
        final card = controller.card;
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Card'),
                      content: const Text('Are you sure you want to delete this card?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true) {
                    try {
                      await controller.deleteCard();
                      Get.back(result: true);
                    } catch (e) {
                      Snackbar.showError(e.toString(), context);
                    }
                  }
                },
                icon: const Icon(Icons.delete, color: Colors.white),
              ),
            ],
            centerTitle: true,
            title: const Text(
              'Edit Card',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          body: SafeArea(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Card Info',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('**** **** **** ${card?.last4 ?? '-'}'),
                            Text(card?.brand ?? ''),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        value: controller.isDefault,
                        onChanged: controller.toggleDefault,
                        title: const Text('Set as default card'),
                        contentPadding: EdgeInsets.zero,
                      ),
                      const SizedBox(height: 16),
                      if (controller.errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.errorMessage!,
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: controller.isSaving
                    ? null
                    : () async {
                        try {
                          await controller.updateCard();
                          Get.back(result: true);
                        } catch (e) {
                          Snackbar.showError(e.toString(), context);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: controller.isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Save'),
              ),
            ),
          ),
        );
      },
    );
  }
}