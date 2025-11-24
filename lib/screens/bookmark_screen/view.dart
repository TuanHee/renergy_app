import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/routes/app_routes.dart';
import 'package:renergy_app/components/components.dart';

import 'controller.dart';
import 'widget/bookmark_item.dart';

class BookmarkScreenView extends StatefulWidget {
  const BookmarkScreenView({super.key});

  @override
  State<BookmarkScreenView> createState() => _BookmarkScreenViewState();
}

class _BookmarkScreenViewState extends State<BookmarkScreenView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await Get.find<BookmarkController>().fetchBookmark();
      } catch (e) {
        if (mounted) {
          Snackbar.showError(e.toString(), context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmark'), centerTitle: true),
      body: GetBuilder<BookmarkController>(
        builder: (controller) {
          return controller.bookmarks.isNotEmpty
              ? ListView.builder(
                  itemCount: controller.bookmarks.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        BookmarkItem(
                          bookmark: controller.bookmarks[index],
                          onTap: () {
                            Get.toNamed(
                              AppRoutes.chargingStation,
                              arguments: controller.bookmarks[index].stationId,
                            );
                          },
                          onRemove: () async {
                            try {
                              final bookmarkId = controller.bookmarks[index].id;
                              await controller.removeBookmark(bookmarkId);
                            } catch (e) {
                              Snackbar.showError(e.toString(), context);
                            }
                          },
                        ),
                        if(index != controller.bookmarks.length)
                        Container(
                          color: Colors.grey[200],
                          height: 2,
                          width: double.infinity,
                        )
                      ],
                    );
                  },
                )
              : SizedBox(    
                width: double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Spacer(),
                      SizedBox(
                        height: 160,
                        width: 120,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.bookmark,
                              size: 140,
                              color: Colors.grey.shade400,
                            ),
                            Positioned(
                              top: 36,
                              right: 10,
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.black87,
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'No bookmark yet',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Tap the bookmark icon besides the station to keep it here.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.black54,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                    ],
                  ),
              );
        },
      ),
      bottomNavigationBar: MainBottomNavBar(currentIndex: 2),
    );
  }
}
