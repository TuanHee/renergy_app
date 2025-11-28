import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:renergy_app/common/models/bookmark.dart';
import 'package:renergy_app/components/badge.dart';

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
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MyBadge(
                        label: (bookmark?.station?.state ?? 'Public'),
                        color: const Color(0xFF0BB07B),
                      ),
                      const SizedBox(width: 8),
                      MyBadge(
                        label: 'Showroom',
                        color: Colors.black87,
                        dark: true,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () =>onRemove?.call(),
                        child: Icon(Icons.star, color: Colors.orange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    bookmark?.station?.name ?? '-',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bookmark?.station?.description ?? '',
                    style: TextStyle(color: muted, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.route, size: 16, color: muted),
                      const SizedBox(width: 4),
                      Text('10 km', style: TextStyle(color: muted)),
                      const SizedBox(width: 12),
                      Icon(Icons.ev_station, size: 16, color: muted),
                      const SizedBox(width: 4),
                      Text(
                        (bookmark?.station?.bays?.length ?? '0').toString(),
                        style: TextStyle(color: muted),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        bookmark?.station?.isActive == true
                            ? 'Available'
                            : 'Unavailable',
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.bolt, size: 16, color: Colors.green),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
