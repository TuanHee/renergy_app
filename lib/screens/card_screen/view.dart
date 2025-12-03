import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/models/credit_card.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/components/components.dart';

import 'controller.dart';
import 'widget/card_widget.dart';

// Main Card Storage Page
class CardScreenView extends StatefulWidget {
  const CardScreenView({Key? key}) : super(key: key);

  @override
  State<CardScreenView> createState() => _CardScreenViewState();
}

class _CardScreenViewState extends State<CardScreenView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_)async{
      try {
        // await Get.find<CardController>().fetchCardIndex();
      } catch (e) {
        Snackbar.showError(e.toString(), context);
      }
    });
  }

  void _deleteCard(CreditCard card) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Card'),
        content: const Text('Are you sure you want to delete this card?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
                await Get.find<CardController>().deleteCard(card);
                if (mounted) {
                  Navigator.pop(context);
                }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.grey.shade100,
          appBar: AppBar(title: const Text('My Cards'), centerTitle: true),
          body: controller.cards.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Illustration with charging station icon
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            // Light gray circle background
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                shape: BoxShape.circle,
                              ),
                            ),
                            // Charging station icon
                            const Icon(
                              Icons.credit_card,
                              size: 120,
                              color: Colors.grey,
                            ),
                            // Map pin with X overlay on bottom right
                          ],
                        ),
                        const SizedBox(height: 48),

                        const Text(
                          'No cards added yet',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        // Explanatory text
                        Text(
                          'Tap + to add your first card',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.cards.length,
                  itemBuilder: (context, index) {
                    final card = controller.cards[index];
                    return GestureDetector(
                      onTap: () async {
                        // final result = await Get.toNamed(AppRoutes.editCard, arguments: card);
                        // if (result == true) {
                        //   try {
                        //     await Get.find<CardController>().fetchCardIndex();
                        //   } catch (e) {
                        //     Snackbar.showError(e.toString(), context);
                        //   }
                        // }
                      },
                      child: CardWidget(
                        card: card,
                        onDelete: () => _deleteCard(card),
                        onSetDefault: () async {
                          try {
                            await Get.find<CardController>().setDefaultCard(card);
                          } catch (e) {
                            Snackbar.showError(e.toString(), context);
                          }
                        },
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              try {
                controller.addCard();
              } catch (e) {
                Snackbar.showError(e.toString(), context);
              }
            },
            backgroundColor: Color(0xFFD32F2F),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      },
    );
  }
}

// Card Widget to display individual cards
