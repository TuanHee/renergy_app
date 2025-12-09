import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/models/credit_card.dart';
import '../controller.dart';

class CardWidget extends StatelessWidget {
  final CreditCard card;
  final VoidCallback onDelete;
  final VoidCallback? onSetDefault;
  final bool isSelectingCard;

  const CardWidget({
    super.key,
    required this.card,
    required this.onDelete,
    this.onSetDefault,
    this.isSelectingCard = false,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(
      builder: (controller) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                if (isSelectingCard) {
                  onSetDefault?.call();
                }
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(card.brandLogo, width: 40, height: 30),
                            Expanded(
                              child: Text(
                                '**** **** **** ${card.last4}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),
                            PopupMenuButton(
                              icon: const Icon(
                                Icons.more_vert,
                                color: Colors.black,
                              ),
                              itemBuilder: (context) => [
                                if (isSelectingCard)
                                  PopupMenuItem(
                                    onTap: onSetDefault,
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          size: 20,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Select this card to pay',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (!isSelectingCard) ...[
                                  PopupMenuItem(
                                    enabled:
                                        !card.isDefault && onSetDefault != null,
                                    onTap: onSetDefault,
                                    child: Row(
                                      children: [
                                        Icon(
                                          card.isDefault
                                              ? Icons.check_circle
                                              : Icons.star,
                                          size: 20,
                                          color: card.isDefault
                                              ? Colors.green
                                              : Colors.black,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          card.isDefault
                                              ? 'Default card'
                                              : 'Set as default',
                                          style: TextStyle(
                                            color: card.isDefault
                                                ? Colors.green
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem(
                                    onTap: onDelete,
                                    child: const Row(
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Delete',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         const Text(
                        //           'Expires',
                        //           style: TextStyle(color: Colors.white70, fontSize: 10),
                        //         ),
                        //         const SizedBox(height: 4),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: card.isDefault
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green.shade300),
                      ),
                      child: controller.isSettingDefault
                          ? const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.green,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, size: 8, color: Colors.green),
                                SizedBox(width: 4),
                                Text(
                                  isSelectingCard ? 'Selected' : 'Default',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }
}
