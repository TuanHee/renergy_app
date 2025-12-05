import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:renergy_app/common/models/bookmark.dart';
import 'package:renergy_app/components/badge.dart';
import 'package:renergy_app/components/snackbar.dart';
import 'package:renergy_app/main.dart';
import 'package:renergy_app/screens/bookmark_screen/controller.dart';

class BookmarkItem extends StatelessWidget {
  final Bookmark? bookmark;
  final Function? onTap;
  final Function? onRemove;

  const BookmarkItem({super.key, this.bookmark, this.onTap, this.onRemove});

  @override
  Widget build(BuildContext context) {
    final muted = Colors.grey.shade600;
    return InkWell(
      onTap: () => onTap?.call(),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  bookmark?.station?.mainImageUrl ?? '',
                  width: 108,
                  height: 81,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 108,
                    height: 90,
                    color: Colors.grey.shade200,
                    child: Image.asset(
                      'assets/images/image_placeholder.png',
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Details
                GetBuilder<BookmarkController>(
                  builder: (controller) {
                    final bookmarkIndex = controller.bookmarks.indexWhere(
                      (bookmark) => bookmark.stationId == bookmark.station?.id,
                    );
                    return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              MyBadge(
                                label:
                                    '${bookmark?.station?.type![0].toUpperCase()}${bookmark?.station?.type!.substring(1)}',
                                color: const Color(0xFF0BB07B),
                              ),
                              const SizedBox(width: 8),
                              if (bookmark?.station?.category != null)
                                MyBadge(
                                  label: bookmark!.station!.category!,
                                  color: Colors.black87,
                                  dark: true,
                                ),
                              const Spacer(),
                              InkWell(
                                onTap: () async {
                                  try {
                                    if (bookmarkIndex >= 0) {
                                      final bookmarkId = controller
                                          .bookmarks[bookmarkIndex]
                                          .id;
                                      await controller.removeBookmark(
                                        bookmarkId,
                                      );
                                    } else {
                                      await controller.removeBookmark(bookmark!.id!);
                                    }
                                  } catch (e) {
                                    Snackbar.showError(e.toString(), context);
                                  }
                                },
                                child: Icon(
                                  bookmarkIndex >= 0
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: bookmarkIndex >= 0
                                      ? Colors.orange
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            bookmark?.station?.name ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (bookmark?.station?.description != null &&
                              bookmark?.station?.description!.isNotEmpty == true) ...[
                            const SizedBox(height: 2),
                            Text(
                              bookmark!.station!.description!,
                              style: TextStyle(color: muted, fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 12.0, 12.0, 0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        // Distance
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.route, size: 14, color: muted),
                              const SizedBox(width: 6),
                              Text(
                                '${bookmark!.station!.distanceTo(Get.find<MainController>().position!).toStringAsFixed(2)} km',
                                style: TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        // Bays count
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.ev_station, size: 14, color: muted),
                              const SizedBox(width: 6),
                              Text(
                                '${bookmark!.station!.bays?.length ?? 0} bays',
                                style: TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        // Availability
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                bookmark!.station!.isActive ? Icons.check_circle : Icons.cancel,
                                size: 14,
                                color: bookmark!.station!.isActive ? Colors.green.shade700 : Colors.red.shade700,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                bookmark!.station!.isActive ? 'Available' : 'Unavailable',
                                style: TextStyle(
                                  color: bookmark!.station!.isActive ? Colors.green.shade700 : Colors.red.shade700,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Schedule (simplified)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.03),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.schedule, size: 14, color: muted),
                              const SizedBox(width: 6),
                              Text(
                                DateTime.now().weekday == DateTime.monday
                                    ? 'Open • 09:00–23:59'
                                    : 'Open • 00:00–23:59',
                                style: TextStyle(color: muted, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Row(
            //   children: [
            //     Expanded(
            //       child: OutlinedButton(
            //         onPressed: () async {
            //           await showModalBottomSheet(
            //             context: context,
            //             shape: const RoundedRectangleBorder(
            //               borderRadius: BorderRadius.vertical(
            //                 top: Radius.circular(16),
            //               ),
            //             ),
            //             builder: (ctx) {
            //               return SafeArea(
            //                 top: false,
            //                 child: Padding(
            //                   padding: const EdgeInsets.symmetric(
            //                     horizontal: 16,
            //                     vertical: 12,
            //                   ),
            //                   child: Column(
            //                     mainAxisSize: MainAxisSize.min,
            //                     crossAxisAlignment: CrossAxisAlignment.start,
            //                     children: [
            //                       const Text(
            //                         'Open with',
            //                         style: TextStyle(
            //                           fontSize: 16,
            //                           fontWeight: FontWeight.w600,
            //                         ),
            //                       ),
            //                       const SizedBox(height: 8),
            //                       ListTile(
            //                         leading: const Icon(
            //                           Icons.map,
            //                           color: Colors.redAccent,
            //                         ),
            //                         title: const Text('Google Maps'),
            //                         onTap: () async {
            //                           Navigator.of(ctx).pop();
            //                           final lat = double.tryParse(
            //                             station.latitude ?? '',
            //                           );
            //                           final lon = double.tryParse(
            //                             station.longitude ?? '',
            //                           );
            //                           if (lat == null || lon == null) return;
            //                           final url = Uri.parse(
            //                             'https://www.google.com/maps/dir/?api=1&destination=$lat,$lon',
            //                           );
            //                           await launchUrl(
            //                             url,
            //                             mode: LaunchMode.externalApplication,
            //                           );
            //                         },
            //                       ),
            //                       ListTile(
            //                         leading: const Icon(
            //                           Icons.navigation,
            //                           color: Colors.blueAccent,
            //                         ),
            //                         title: const Text('Waze'),
            //                         onTap: () async {
            //                           Navigator.of(ctx).pop();
            //                           final lat = double.tryParse(
            //                             station.latitude ?? '',
            //                           );
            //                           final lon = double.tryParse(
            //                             station.longitude ?? '',
            //                           );
            //                           if (lat == null || lon == null) return;
            //                           final url = Uri.parse(
            //                             'https://waze.com/ul?ll=$lat,$lon&navigate=yes',
            //                           );
            //                           await launchUrl(
            //                             url,
            //                             mode: LaunchMode.externalApplication,
            //                           );
            //                         },
            //                       ),
            //                       const SizedBox(height: 8),
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             },
            //           );
            //         },
            //         child: const Text('Navigate'),
            //       ),
            //     ),
            //     const SizedBox(width: 12),
            //     Expanded(
            //       child: ElevatedButton(
            //         onPressed: () {
            //           Get.toNamed(
            //             AppRoutes.chargingStation,
            //             arguments: station.id,
            //           );
            //         },
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: Colors.red.shade700,
            //           foregroundColor: Colors.white,
            //         ),
            //         child: const Text('Charge'),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
