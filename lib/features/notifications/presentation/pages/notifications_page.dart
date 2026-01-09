import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pms/core/constants/app_colors.dart';
import 'package:pms/core/constants/app_theme.dart';
import 'package:pms/features/notifications/data/models/notification_model.dart';
import 'package:pms/features/notifications/presentation/providers/notification_provider.dart';
import 'package:pms/shared/widgets/feedback/loading_indicator.dart';
import 'package:pms/shared/widgets/feedback/empty_state_widget.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Consumer<NotificationProvider>(
            builder: (context, provider, _) {
              if (provider.unreadCount > 0) {
                return TextButton(
                  onPressed: () => provider.markAllAsRead(),
                  child: const Text('Mark all as read'),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'clear') {
                context.read<NotificationProvider>().clearAll();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear all'),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<NotificationProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const LoadingIndicator(message: 'Loading notifications...');
          }

          if (provider.errorMessage != null) {
            return EmptyStateWidget(
              icon: Icons.error_outline,
              title: 'Error',
              message: provider.errorMessage!,
              actionButtonText: 'Retry',
              onActionPressed: () => provider.loadNotifications(),
            );
          }

          if (provider.notifications.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.notifications_off_outlined,
              title: 'No Notifications',
              message: 'You are all caught up!',
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.loadNotifications(),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppTheme.medium),
              itemCount: provider.notifications.length,
              separatorBuilder: (context, index) => const SizedBox(height: AppTheme.small),
              itemBuilder: (context, index) {
                final notification = provider.notifications[index];
                return _buildNotificationItem(context, notification, provider);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    NotificationModel notification,
    NotificationProvider provider,
  ) {
    return Card(
      elevation: notification.isRead ? 0 : 2,
      color: notification.isRead 
          ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
          : null,
      child: InkWell(
        onTap: () {
          provider.markAsRead(notification.id);
          // TODO: Add deep linking based on notification type
        },
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.medium),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(AppTheme.small),
                decoration: BoxDecoration(
                  color: _getNotificationColor(notification.type).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getNotificationIcon(notification.type),
                  color: _getNotificationColor(notification.type),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                              fontSize: AppTheme.fontSizeBody1,
                            ),
                          ),
                        ),
                        Text(
                          notification.timeAgo,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: notification.isRead ? Colors.grey : null,
                          ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  margin: const EdgeInsets.only(left: 8, top: 4),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.lightPrimary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.fee: return AppColors.lightError;
      case NotificationType.event: return AppColors.lightSuccess;
      case NotificationType.diary: return AppColors.lightPrimary;
      case NotificationType.attendance: return AppColors.lightWarning;
      case NotificationType.announcement: return AppColors.lightInfo;
      case NotificationType.other: return Colors.grey;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.fee: return Icons.account_balance_wallet;
      case NotificationType.event: return Icons.event;
      case NotificationType.diary: return Icons.book;
      case NotificationType.attendance: return Icons.calendar_today;
      case NotificationType.announcement: return Icons.campaign;
      case NotificationType.other: return Icons.notifications;
    }
  }
}
