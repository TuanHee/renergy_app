import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:renergy_app/components/components.dart';

import 'controller.dart';

class NotificationScreenView extends StatefulWidget {
  const NotificationScreenView({super.key});

  @override
  State<NotificationScreenView> createState() => _NotificationScreenViewState();
}

class _NotificationScreenViewState extends State<NotificationScreenView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        centerTitle: true,
        actions: const [],
      ),
      body: GetBuilder<NotificationController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.notifications.isEmpty) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.notifications_none, size: 96, color: Colors.grey),
                  const SizedBox(height: 12),
                  Text(
                    'No notifications yet',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You’ll see charging updates and alerts here.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: controller.notifications.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
            itemBuilder: (context, index) {
              final n = controller.notifications[index];
              // Determine unread based on presence of read_at inside data
              final bool isUnread = n.readAt == null;

              IconData leadingIcon = Icons.notifications_active;
              Color leadingColor = isUnread ? theme.colorScheme.primary : Colors.blueGrey;

              return Dismissible(
                key: ValueKey(index),
                background: Container(
                  color: Colors.red.shade400,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => controller.deleteAt(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isUnread
                        ? theme.colorScheme.primary.withOpacity(0.06)
                        : Colors.transparent,
                    border: isUnread
                        ? Border(
                            left: BorderSide(
                              color: theme.colorScheme.primary,
                              width: 4,
                            ),
                          )
                        : null,
                  ),
                  child: ListTile(
                    leading: Icon(leadingIcon, color: leadingColor, size: 24),
                    title: Text(
                      n.title ?? 'Notification',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                        color: isUnread ? theme.colorScheme.primary : Colors.black87,
                      ),
                    ),
                    subtitle: Text(
                      n.message ?? '',
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    ),
                    trailing: isUnread
                        ? Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'New',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        : null,
                    onTap: () {
                      if (n.goto != null && n.goto!.isNotEmpty) {
                        Get.toNamed(n.goto!, arguments: n.data);
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}